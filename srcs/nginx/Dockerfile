FROM alpine:3.22

# Install the application dependencies
RUN sudo apk add nginx
COPY srcs/nginx/conf.conf /etc/nginx/nginx.conf

# Expose nginx port
EXPOSE 443

CMD ['echo', '>', '/var/www/html/index.html', 'hello !']
CMD ['service', 'nginx', 'start']

