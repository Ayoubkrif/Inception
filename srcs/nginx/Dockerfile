FROM alpine:3.22

# Install the application dependencies
RUN apk add nginx
COPY conf.conf /etc/nginx/nginx.conf

# Expose nginx port
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]

