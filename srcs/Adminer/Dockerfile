FROM alpine:3.22
#NOTE: Install the application dependencies
RUN apk add --no-cache php84 php84-pdo_mysql php84-session curl \
    && mkdir -p /var/www \
    && curl -Lo /var/www/adminer.php \
       https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2-mysql.php

#NOTE: Expose conf listen port
EXPOSE 8080

#NOTE: First command to launch
CMD ["php84", "-S", "0.0.0.0:8080", "/var/www/adminer.php"]

