FROM alpine:3.22
#INFO: Install the application dependencies
#HACK: mariadb of alpine is mariadb-server of debian
# No need galera ?
RUN apk add mariadb mariadb-client
# RUN apk add galera

#NOTE: Docker script convention
COPY healthcheck.sh /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

#NOTE: First command to launch
ENTRYPOINT ["docker-entrypoint.sh"]

#NOTE: Arguments
# CMD [""]
