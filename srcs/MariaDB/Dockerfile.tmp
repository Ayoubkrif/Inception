FROM alpine:3.22

RUN apk add --no-cache mariadb mariadb-client su-exec \
	&& rm -rf /var/lib/mysql \
	&& mkdir -p /var/lib/mysql /run/mysqld \
	&& chown -R mysql:mysql /var/lib/mysql /run/mysqld \
	&& chmod 1777 /run/mysqld \
	&& printf '[mysqld]\nskip-networking=OFF\nbind-address=0.0.0.0\n' \
		> /etc/my.cnf.d/inception.cnf

COPY --chmod=755 healthcheck.sh /usr/local/bin/
COPY --chmod=755 docker-entrypoint.sh /usr/local/bin/

HEALTHCHECK --interval=1s --timeout=3s --start-period=30s --retries=15 \
	CMD healthcheck.sh

ENTRYPOINT ["docker-entrypoint.sh"]
