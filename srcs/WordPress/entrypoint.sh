#!/bin/bash

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
wp --info
# PHP Fatal error:  Allowed memory size of 134217728 bytes exhausted (tried to allocate 36864 bytes) in phar:///usr/local/bin/wp/vendor/wp-cli/wp-cli/php/WP_CLI/Extractor.php on line 100
# Increase memory limit for extraction
RUN echo "memory_limit=256M" >> /etc/php83/php.ini
# Tuto quick start wp
wp core download --path=wpclidemo.dev

tail -f /dev/null
