FROM alpine:3.22
# NOTE: Install the application dependencies
RUN apk add nginx
# NOTE: Copy conf in default conf folder
COPY conf.conf /etc/nginx/nginx.conf
# NOTE: Expose conf listen port
# informe que 443 est ouvert pour tout le monde
EXPOSE 443

# NOTE: First command to launch
ENTRYPOINT ["nginx"]
# NOTE: Arguments
CMD ["-g", "daemon off;"]
