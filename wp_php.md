# PHP packages pour WordPress sur Alpine

Source : https://wpalex.fr/tutoriel/pre-requis-php-indispensables-pour-wordpress-guide-complet-2025/

## Obligatoires — WordPress ne démarre pas sans

| Package | Pourquoi |
|---|---|
| `php83` | PHP de base |
| `php83-fpm` | FastCGI Process Manager — NGINX l'appelle pour exécuter PHP |
| `php83-mysqli` | Connexion MariaDB |
| `php83-pdo_mysql` | Certains plugins utilisent PDO plutôt que mysqli |
| `php83-mysqlnd` | Driver natif MySQL, améliore les perfs de mysqli/pdo_mysql |
| `php83-session` | Sessions utilisateur (login wp-admin) |
| `php83-phar` | Format d'archive PHP — requis pour exécuter WP-CLI |
| `php83-openssl` | Connexions HTTPS sortantes, chiffrement |
| `php83-ctype` | Validation de types de caractères, utilisé en interne |
| ~~`php83-json`~~ | **Intégré dans php83** — pas de paquet séparé |
| ~~`php83-filter`~~ | **Intégré dans php83** — pas de paquet séparé |

## Internes WordPress — risque de crash silencieux sans eux

| Package | Pourquoi |
|---|---|
| `php83-dom` | Parse HTML/XML en interne, RSS |
| `php83-xml` | Dépendance de dom, sitemaps, exports |
| `php83-simplexml` | Lecture de flux RSS et fichiers XML |
| `php83-xmlreader` | Lecture de gros fichiers XML |
| `php83-mbstring` | Chaînes multilingues, UTF-8 |
| `php83-iconv` | Conversion d'encodage (complément de mbstring) |
| `php83-fileinfo` | Détection du type MIME des fichiers uploadés |
| `php83-exif` | Lecture des métadonnées EXIF des images |
| ~~`php83-zlib`~~ | **Intégré dans php83** — pas de paquet séparé |

## Optionnels — selon usage

| Package | Pourquoi |
|---|---|
| `php83-curl` | Appels API plugins (Yoast, UpdraftPlus…) — WP-CLI utilise le binaire curl, pas cette extension |
| `php83-gd` | Génération de thumbnails |
| `php83-zip` | Installation plugins/thèmes via interface web |
| `php83-opcache` | Cache bytecode compilé — WordPress plus rapide (min 128 MB) |
| `php83-intl` | Localisation dates, devises, formats |
| `php83-sodium` | Chiffrement moderne (libsodium), hash de mots de passe |

## Minimum strict pour que WordPress + WP-CLI démarrent

```
php83 php83-fpm php83-mysqli php83-session php83-phar
php83-json php83-openssl php83-ctype php83-filter
php83-dom php83-xml php83-mbstring php83-fileinfo
```
