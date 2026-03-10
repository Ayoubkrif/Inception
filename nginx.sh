#!/bin/bash

echo > $NGINX_DIR/$NGINX_CONF "\
server {
	listen $NGINX_PORT;
	location / {
		root /var/www/html;
	}
}
"
echo > $NGINX_DIR/Dockerfile "\
FROM $IMAGE

# Install the application dependencies
RUN sudo apk add nginx
COPY $NGINX_DIR/$NGINX_CONF /etc/nginx/nginx.conf

# Expose nginx port
EXPOSE $NGINX_PORT

CMD ['echo', '>', '/var/www/html/index.html', 'hello !']
CMD ['service', 'nginx', 'start']
"
