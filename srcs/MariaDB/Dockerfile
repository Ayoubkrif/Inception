FROM alpine:3.22
#INFO: Install the application dependencies
#HACK: mariadb of alpine is mariadb-server of debian
# No need galera ?
RUN apk add mariadb mariadb-client
# RUN apk add galera

COPY entrypoint.sh .

# First command to launch
ENTRYPOINT ["sh"]
# Arguments
CMD ["entrypoint.sh"]
