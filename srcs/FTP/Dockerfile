FROM alpine:3.22

RUN apk add --no-cache vsftpd \
    && mkdir -p /var/empty \
    && chmod 755 /var/empty

COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

#NOTE: 21100: in passive mode need a second port for data transfer assigned by ftp server to the client
EXPOSE 21 21100

ENTRYPOINT ["/docker-entrypoint.sh"]
