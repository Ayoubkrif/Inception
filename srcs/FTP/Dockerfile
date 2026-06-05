FROM alpine:3.22

RUN apk add --no-cache vsftpd openssl \
    && mkdir -p /var/empty \
    && chmod 755 /var/empty

COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 21 21100-21110

ENTRYPOINT ["/docker-entrypoint.sh"]
