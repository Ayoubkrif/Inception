# MariaDB — Alpine vs Debian

## Tailles d'image

| Base         | Image finale |
|--------------|-------------|
| debian:bookworm | ~377 MB  |
| alpine:3.22     | ~243 MB  |

---

## Dockerfile

| | Debian | Alpine |
|---|---|---|
| Base | `debian:bookworm` | `alpine:3.22` |
| Package manager | `apt-get install mariadb-server` | `apk add mariadb mariadb-client su-exec` |
| Nettoyage cache | `rm -rf /var/lib/apt/lists/* /usr/share/doc/* /usr/share/man/*` | inclus dans `--no-cache` |
| Réseau | `find /etc/mysql/ … sed` pour commenter `bind-address` | `printf '[mysqld]\nskip-networking=OFF\nbind-address=0.0.0.0' > /etc/my.cnf.d/inception.cnf` |
| Raison fix réseau | Debian bind à `127.0.0.1` par défaut | Alpine active `skip-networking` par défaut — désactiver via CLI obligatoire car `[mysqld]` ignoré sur MariaDB 11.x (lit `[mariadbd]`) |

---

## docker-entrypoint.sh

| | Debian (`.tmp`) | Alpine (actif) |
|---|---|---|
| Shell | `#!/bin/bash` | `#!/bin/sh` |
| Options | `set -eo pipefail` | `set -e` (`pipefail` non disponible en ash) |
| Date | `date --rfc-3339=seconds` | `date '+%Y-%m-%d %H:%M:%S'` (busybox) |
| Élévation user | `runuser -u mysql --` | `su-exec mysql` |
| Boucle attente | `for i in {30..0}` (brace expansion bash) | `while [ "$i" -ge 0 ]` avec `i=$((i-1))` |
| Détection timeout | `[ "$i" = 0 ]` (dernière valeur = 0) | `[ "$i" -lt 0 ]` (sort à -1 après épuisement) |
| Client MariaDB | `mysql` | `mariadb` |
| Admin client | `mysqladmin` | `mariadb-admin` |
| Daemon final | `exec runuser -u mysql -- mysqld --datadir=…` | `exec su-exec mysql mysqld --datadir=… --skip-networking=OFF --bind-address=0.0.0.0` |
| User healthcheck | `CREATE USER 'healthcheck'@'localhost'` (vestige supprimé) | absent |

---

## healthcheck.sh (commun aux deux)

```sh
#!/bin/sh
mariadb --skip-ssl --protocol=socket \
    -u root -p"$(cat /run/secrets/mariadb_root_password)" \
    -e "SELECT 1 FROM information_schema.ENGINES WHERE engine='InnoDB' AND support IN ('YES','DEFAULT')" \
    >/dev/null 2>&1
```

Vérifie que le serveur répond **et** qu'InnoDB est opérationnel — pas juste un ping protocole.

---

## Pourquoi `su-exec` sur Alpine et `runuser` sur Debian ?

`runuser` vient de `util-linux`. Sur Debian il est préinstallé. Sur Alpine il faut l'installer
séparément (`apk add util-linux`) — `su-exec` est l'alternative standard pour les images Alpine,
plus légère et conçue pour Docker (même usage que `gosu`).
