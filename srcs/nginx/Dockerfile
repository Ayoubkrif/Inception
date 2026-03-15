FROM alpine:3.22

# Install the application dependencies
RUN apk add nginx
# Copy conf in defau;t conf folder
COPY conf.conf /etc/nginx/nginx.conf

# Expose conf listen port
EXPOSE 443

# First command to launch
CMD ["nginx", "-g", "daemon off;"]

