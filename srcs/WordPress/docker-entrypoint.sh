#!/bin/sh

wp --info
wp core download --path=$WP_FILES_LOCATION # convention: répertoire racine des fichiers sources web

#NOTE: II Créer wp-config.php en pointant vers ton container MariaDB
# ? root_password=$(cat /run/secrets/mariadb_root_password) ?
MYSQL_PASSWORD=$(cat /run/secrets/mariadb_password)
wp config create \
  --dbname=$MYSQL_DATABASE \
  --dbuser=$MYSQL_USER \
  --dbpass=$MYSQL_PASSWORD \
  --dbhost=MariaDB \
  --path=$WP_FILES_LOCATION

#NOTE: III NO wp db create — MariaDB already created

#NOTE: IV wp install
# wp core install \
#   --url="?" \
#   --title="demo" \
#   --admin_user="wp_admin" \
#   --admin_password="adm" \
#   --admin_email="mail@mail.mail" \
#   --path=$WP_FILES_LOCATION

tail -f /dev/null
