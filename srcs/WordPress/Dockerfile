FROM alpine:3.22

#NOTE: Required — WordPress won't start without these
# curl (CLI) is used by the entrypoint to download WP-CLI
RUN apk add php83 php83-fpm php83-mysqli php83-pdo_mysql php83-mysqlnd \
            php83-session php83-phar php83-openssl php83-ctype curl

#NOTE: WordPress internals — risk of silent crash without these
RUN apk add php83-dom php83-xml php83-simplexml php83-xmlreader \
            php83-mbstring php83-iconv php83-fileinfo php83-exif

#PERF: Optional — uncomment if needed at runtime
# RUN apk add php83-curl php83-gd php83-zip php83-opcache php83-intl php83-sodium

#PERF: Download in dockerfile for a complete image and avoid dl while building the container
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar ;\
	chmod +x wp-cli.phar; \
	mv wp-cli.phar /usr/local/bin/wp

RUN adduser -S -G www-data www-data 2>/dev/null || true
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html
WORKDIR /var/www/html

#FIX: Allowed memory size exhausted during wp-cli extraction
RUN echo "memory_limit=256M" >> /etc/php83/php.ini

RUN sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/' /etc/php83/php-fpm.d/www.conf

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
