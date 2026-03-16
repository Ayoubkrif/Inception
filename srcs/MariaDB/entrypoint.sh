#!/bin/bash

echo "--- 1. Récupération des variables et secrets ---"
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mariadb_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/mariadb_password)
# MYSQL_DATABASE et MYSQL_USER sont déjà dans l'environnement grâce au .env

echo "--- 2. Nettoyage de sécurité ---"
# On s'assure que le dossier est vide avant d'installer (utile pour les tests)
rm -rf /var/lib/mysql/*

echo "--- 3. Initialisation système (mariadb-install-db) ---"
# La commande officielle pour créer l'architecture de base de données
mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db

echo "--- 4. Configuration des accès via Bootstrap ---"
# On démarre le serveur juste le temps de lui passer les commandes SQL
mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

-- 4a. Sécurisation du compte ROOT
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- 4b. Création de la base et de l'utilisateur WordPress
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

echo "--- 5. Démarrage final du serveur ---"
echo "Les bases sont prêtes ! Lancement de MariaDB en arrière-plan..."
# On lance le serveur en arrière-plan pour te rendre la main sur le terminal
mysqld --user=mysql &

echo ""
echo ">>> Succès ! Tu peux maintenant tester la connexion avec :"
echo ">>> mariadb -u root -p"
