# MariaDB Provisioning

## Approche

Inspiré du [dépôt officiel MariaDB Docker](https://github.com/MariaDB/mariadb-docker),
adapté et réduit au strict nécessaire pour le projet Inception.

Le script officiel fait ~720 lignes pour couvrir tous les cas (réplication, healthcheck users,
timezones, mot de passe aléatoire, initdb.d...). Ici on garde les 5 étapes fondamentales.

## Séquence de démarrage

```
1. mariadb-install-db   → initialise les fichiers système dans /var/lib/mysql
2. chown mysql:mysql    → corrige les permissions pour le user mysql
3. mysqld (temp)        → serveur sans réseau pour le provisioning
4. SQL                  → root password + database + user + grants
5. kill temp server     → arrêt propre
6. exec mysqld          → daemon final en PID 1
```

## Différences avec l'image officielle

| Officiel | Ici |
|---|---|
| `gosu mysql` pour drop privileges | `runuser -u mysql` (disponible sur Debian sans install) |
| Gestion timezones | Non (inutile pour WordPress) |
| Healthcheck user | Non |
| Replication user | Non |
| Mot de passe aléatoire | Non (Docker secrets) |
| `initdb.d/` | Non |
| ~720 lignes | ~70 lignes |

## Variables attendues

| Source | Variable | Usage |
|---|---|---|
| env (compose) | `MYSQL_DATABASE` | Nom de la base WordPress |
| env (compose) | `MYSQL_USER` | Utilisateur WordPress |
| secret | `mariadb_root_password` | Mot de passe root |
| secret | `mariadb_password` | Mot de passe user WordPress |

## Problèmes rencontrés

- `mariadb-install-db` échoue si les fichiers de config Debian contiennent `user = mysql`
  → fix : `--defaults-file=/dev/null` pour ignorer les configs système

- `mysqld --user=mysql` fait un `chdir("/")` en interne lors du drop de privileges,
  ce qui rend `./ddl_recovery.log` non accessible au user mysql
  → fix : `runuser -u mysql -- mysqld` pour démarrer directement en tant que mysql

- Le volume bind mount (sur filesystem 9p/vboxsf) ne supporte pas `chown` :
  même en root dans le container, l'ownership ne change pas
  → fix : volume Docker natif (`driver: local` sans `driver_opts`)

- Au restart du container, l'entrypoint ré-initialisait tout et tentait de se connecter
  avec un password vide alors que root avait déjà un vrai password settée
  → fix : guard `[ ! -d /var/lib/mysql/mysql ]` pour ne provisionner qu'une seule fois

- Connexion au temp server échoue (`Access denied`) car `--auth-root-authentication-method`
  n'était pas explicitement défini — le client tentait de se connecter sans password
  alors que root utilisait l'auth par défaut de Debian (unix_socket)
  → fix : `--auth-root-authentication-method=normal` dans `mariadb-install-db`
  + `mysql -u root --password=''` pour la connexion initiale
