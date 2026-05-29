#!/bin/sh
set -e

# convention: /var/www/html = racine des fichiers sources web
wp core download --path=$WP_FILES_LOCATION --allow-root

# II — wp-config.php → pointe vers le container MariaDB
MYSQL_PASSWORD=$(cat /run/secrets/mariadb_password)
wp config create \
  --dbname=$MYSQL_DATABASE \
  --dbuser=$MYSQL_USER \
  --dbpass=$MYSQL_PASSWORD \
  --dbhost=MariaDB \
  --path=$WP_FILES_LOCATION \
  --allow-root \
  --force

# III — NO wp db create, MariaDB provisionne déjà la DB

# IV — Installation WordPress (idempotent : skip si les tables existent déjà)
if ! wp core is-installed --path=$WP_FILES_LOCATION --allow-root 2>/dev/null; then
  WP_ADMIN_PASS=$(cat /run/secrets/wp_admin_password)
  wp core install \
    --url=https://$DOMAIN_NAME \
    --title="$WP_TITLE" \
    --admin_user=$WP_ADMIN_USER \
    --admin_password=$WP_ADMIN_PASS \
    --admin_email=$WP_ADMIN_EMAIL \
    --skip-email \
    --path=$WP_FILES_LOCATION \
    --allow-root

  # V — Deuxième utilisateur (sujet : 2 users, pas admin dans le login)
  WP_USER_PASS=$(cat /run/secrets/wp_user_password)
  wp user create $WP_USER $WP_USER_EMAIL \
    --user_pass=$WP_USER_PASS \
    --role=author \
    --path=$WP_FILES_LOCATION \
    --allow-root
fi

# php-fpm en PID 1 (tail -f /dev/null interdit par le sujet)
exec php-fpm83 -F
