FROM alpine:3.22

# NOTE: Required — WordPress won't start without these
# curl (CLI) is used by the entrypoint to download WP-CLI
RUN apk add php83 php83-fpm php83-mysqli php83-pdo_mysql php83-mysqlnd \
            php83-session php83-phar php83-openssl php83-ctype curl

# NOTE: WordPress internals — risk of silent crash without these
RUN apk add php83-dom php83-xml php83-simplexml php83-xmlreader \
            php83-mbstring php83-iconv php83-fileinfo php83-exif

# PERF: Optional — uncomment if needed at runtime
# RUN apk add php83-curl php83-gd php83-zip php83-opcache php83-intl php83-sodium

COPY entrypoint.sh .

ENTRYPOINT ["sh"]
CMD ["entrypoint.sh"]
