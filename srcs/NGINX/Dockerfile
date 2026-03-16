FROM alpine:3.22
# Install the application dependencies
RUN apk add nginx
# Copy conf in defau;t conf folder
COPY conf.conf /etc/nginx/nginx.conf
# Expose conf listen port
# informe que 443 est ouvert pour tout le monde
EXPOSE 443

# First command to launch
ENTRYPOINT ["nginx"]
# Arguments
CMD ["-g", "daemon off;"]
