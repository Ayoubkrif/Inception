# MariaDB — Guide pour l'agent

## Contexte

Ce service est le container MariaDB du projet Inception (42).
L'entrypoint et le Dockerfile sont inspirés du dépôt officiel
[MariaDB/mariadb-docker](https://github.com/MariaDB/mariadb-docker)
mais réduits au strict nécessaire. Le script officiel fait ~720 lignes,
le nôtre ~80. Chaque choix est justifié ci-dessous.

## Fichiers

```
MariaDB/
├── Dockerfile                 # image debian:bookworm
├── docker-entrypoint.sh       # logique de démarrage
├── healthcheck.sh             # vide pour l'instant
├── PROVISIONING.md            # historique des blocages rencontrés
└── CLAUDE.md                  # ce fichier
```

## Dockerfile — explications

```dockerfile
FROM debian:bookworm
# Alpine n'est pas supporté officiellement par MariaDB (pas de mariadb-server).
# debian:bookworm = avant-dernière stable, conforme au sujet 42.

RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld \
    && chmod 1777 /run/mysqld
# /run/mysqld = répertoire du socket Unix de MariaDB.
# Doit être writable par le user mysql avant le démarrage.
# Le chown de /var/lib/mysql est fait au runtime (entrypoint) car
# le volume Docker est monté APRÈS le build — le chown du build ne persiste pas.

COPY healthcheck.sh /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh /usr/local/bin/docker-entrypoint.sh
# Convention Docker : scripts dans /usr/local/bin/ qui est dans le PATH.
# Sans chmod +x, ENTRYPOINT ["docker-entrypoint.sh"] échoue avec "no such file".

ENTRYPOINT ["docker-entrypoint.sh"]
# Exec form (tableau JSON) = le script devient PID 1 directement.
# Shell form ("docker-entrypoint.sh") = lancé via /bin/sh -c, PID 1 = sh.
```

## docker-entrypoint.sh — explications

### Shebang et options

```bash
#!/bin/bash
set -eo pipefail
```
- `bash` obligatoire : on utilise des tableaux, `{30..0}`, `declare` — incompatible avec `sh`.
- `set -e` : arrête le script dès qu'une commande échoue.
- `set -o pipefail` : une erreur dans un pipe (cmd1 | cmd2) est propagée.

### Logging

```bash
mysql_log() {
    printf '%s [%s] [Entrypoint]: %s\n' "$(date --rfc-3339=seconds)" "$type" "$*"
}
```
Convention de l'image officielle. Permet de distinguer les logs de l'entrypoint
des logs de mysqld dans `docker logs`.

### I — Init du datadir

```bash
docker_init_database_dir() {
    chown -R mysql:mysql /var/lib/mysql
    # Le volume Docker est monté par root. On chown au runtime pour que
    # mysql puisse y écrire. Impossible de le faire dans le Dockerfile
    # car le volume overlay les permissions du build.

    mariadb-install-db \
        --defaults-file=/dev/null \
        # Ignore les configs système Debian (/etc/mysql/mariadb.conf.d/).
        # Sans ça, mariadbd interne lit "user = mysql", drop ses privileges,
        # et tente d'écrire ./ddl_recovery.log dans / où mysql n'a pas accès.
        --datadir=/var/lib/mysql \
        --skip-test-db \
        # Ne pas créer la base de test inutile.
        --basedir=/usr \
        --auth-root-authentication-method=normal
        # Root utilise password auth (pas unix_socket).
        # Nécessaire pour pouvoir se connecter avec --password=''
        # au temp server avant que le vrai password soit setté.
}
```

### II — Temp server

```bash
docker_temp_server_start() {
    runuser -u mysql -- mysqld --datadir=/var/lib/mysql --skip-networking --socket=... &
    # runuser -u mysql : démarre mysqld DÉJÀ en tant que mysql.
    # NE PAS utiliser mysqld --user=mysql : cette option fait un chdir("/")
    # en interne lors du drop de privileges, ce qui empêche mysql d'écrire
    # ddl_recovery.log dans ./ (qui devient /).
    # runuser évite le drop de privileges = pas de chdir = pas d'erreur.
    #
    # --skip-networking : pas de port TCP, socket Unix uniquement.
    # Le temp server sert uniquement au provisioning, pas au traffic réel.
}
```

### III — Provisioning

```bash
docker_setup_db() {
    mysql -u root --password='' --socket=... <<-EOSQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${root_password}';
        # On set le vrai password root (depuis le secret Docker).
        # Connexion avec --password='' car root n'a pas encore de password
        # à ce stade (mariadb-install-db crée root avec password vide).

        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${password}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        # '${MYSQL_USER}'@'%' = accepte les connexions depuis n'importe quelle IP.
        # Nécessaire car WordPress est dans un container différent.

        FLUSH PRIVILEGES;
    EOSQL
}
```

### IV — Stop temp server

```bash
docker_temp_server_stop() {
    kill "$MARIADB_PID"
    wait "$MARIADB_PID"
    # wait bloque jusqu'à ce que mysqld soit vraiment arrêté
    # avant de lancer le daemon final.
}
```

### Main — guard d'idempotence

```bash
_main() {
    if [ ! -d "/var/lib/mysql/mysql" ]; then
        # Si le répertoire mysql/ n'existe pas, la DB n'est pas initialisée.
        # Ce guard évite de ré-initialiser au restart du container.
        # Sans ça : au restart, on tente de se connecter avec --password=''
        # alors que root a déjà un vrai password → Access denied.
        docker_init_database_dir
        docker_temp_server_start
        docker_setup_db
        docker_temp_server_stop
    fi
    exec runuser -u mysql -- mysqld --datadir=/var/lib/mysql
    # exec remplace le shell par mysqld → mysqld devient PID 1.
    # PID 1 reçoit les signaux Docker (SIGTERM pour l'arrêt propre).
}
```

## Variables requises

| Source | Variable | Usage |
|---|---|---|
| `env_file` (compose) | `MYSQL_DATABASE` | Nom de la base WordPress |
| `env_file` (compose) | `MYSQL_USER` | Utilisateur WordPress |
| secret Docker | `mariadb_root_password` | Password root MariaDB |
| secret Docker | `mariadb_password` | Password user WordPress |

## Ce que l'étudiant veut faire par lui-même

Ne pas tout implémenter d'un coup. Expliquer si demandé, ne pas surguider.
