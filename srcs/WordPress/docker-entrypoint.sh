#!/bin/sh

wp --info
#FIX: PHP Fatal error:  Allowed memory size of 134217728 bytes exhausted (tried to allocate 36864 bytes) in phar:///usr/local/bin/wp/vendor/wp-cli/wp-cli/php/WP_CLI/Extractor.php on line 100
#NOTE: Increase memory limit for extraction
echo "memory_limit=256M" >> /etc/php83/php.ini
# Tuto quick start wp
wp core download --path=wpclidemo.dev

tail -f /dev/null
