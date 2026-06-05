FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server \
    #HACK: clean for lightweight images
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /usr/share/doc/* /usr/share/man/* \
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

COPY --chmod=755 healthcheck.sh /usr/local/bin/
COPY --chmod=755 docker-entrypoint.sh /usr/local/bin/

# Sends COM_PING via Unix socket as a no-privilege 'healthcheck'@localhost user.
# WordPress depends_on this check (service_healthy) so it never starts before MariaDB is ready.
# start-period=30s gives time for first-run provisioning (mariadb-install-db + temp server).
HEALTHCHECK --interval=1s --timeout=3s --start-period=30s --retries=15 \
    CMD healthcheck.sh

ENTRYPOINT ["docker-entrypoint.sh"]
