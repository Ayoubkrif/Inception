FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/* \
	# ref: MariaDB/mariadb-docker Dockerfile.template l.119-121
	# apt-get post-install initializes /var/lib/mysql — purge it so the named volume
	# starts empty: Docker copies image contents into empty volumes on first mount,
	# which would skip our entrypoint provisioning (guard: [ ! -d /var/lib/mysql/mysql ])
	&& rm -rf /var/lib/mysql \
	&& mkdir -p /var/lib/mysql /run/mysqld \
	&& chown -R mysql:mysql /var/lib/mysql /run/mysqld \
	&& chmod 1777 /run/mysqld \
	# ref: MariaDB/mariadb-docker Dockerfile.template l.126-127
	# Comment out bind-address (defaults to 127.0.0.1 on Debian) so MariaDB
	# listens on all interfaces — required for cross-container connections
	&& find /etc/mysql/ -name '*.cnf' -print0 \
		| xargs -0 grep -lZE '^(bind-address|log|user\s)' \
		| xargs -rt -0 sed -Ei 's/^(bind-address|log|user\s)/#&/'

COPY healthcheck.sh /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
