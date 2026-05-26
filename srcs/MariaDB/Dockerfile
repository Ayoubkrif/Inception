FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /run/mysqld \
	&& chown -R mysql:mysql /run/mysqld \
	&& chmod 1777 /run/mysqld

COPY healthcheck.sh /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
