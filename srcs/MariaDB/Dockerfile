FROM debian:bookworm
# Install the application dependencies
RUN apt update
RUN apt install -y mariadb-server mariadb-client galera-4

# 2. Créer les dossiers nécessaires avec les bons propriétaires (mysql)
RUN mkdir -p /var/run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /var/run/mysqld /var/lib/mysql && \
    chmod 777 /var/run/mysqld

# 3. Copier le script d'installation
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# First command to launch
ENTRYPOINT ["sh"]
CMD ["entrypoint.sh"]
