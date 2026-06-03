FROM alpine:3.22

# 1. PHP extensions required by WordPress + curl for WP-CLI download
#    Optional (uncomment if needed): php83-curl php83-gd php83-zip php83-opcache php83-intl php83-sodium
# 2. WP-CLI — baked into the image to avoid a download at container startup
# 3. Dedicated www-data user + /var/www/html with correct ownership
# 4. PHP tweaks: memory_limit=256M (FIX: exhausted during wp-cli extraction)
#               php-fpm listen on 0.0.0.0:9000 (required for cross-container connections)
RUN apk add --no-cache \
        php83 php83-fpm php83-mysqli php83-pdo_mysql php83-mysqlnd \
        php83-session php83-phar php83-openssl php83-ctype curl \
        php83-dom php83-xml php83-simplexml php83-xmlreader \
        php83-mbstring php83-iconv php83-fileinfo php83-exif \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    #HACK: clean for lightweight images
    && apk del curl \
    && adduser -S -G www-data www-data 2>/dev/null || true \
    && mkdir -p /var/www/html \
    && chown -R www-data:www-data /var/www/html \
    && echo "memory_limit=256M" >> /etc/php83/php.ini \
    && sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/' /etc/php83/php-fpm.d/www.conf

WORKDIR /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
