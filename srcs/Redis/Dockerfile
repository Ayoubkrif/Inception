#INFO: from: https://oneuptime.com/blog/post/2026-03-31-redis-install-alpine-linux/
FROM alpine:3.22

RUN apk add --no-cache redis

# Copy a custom config
COPY redis.conf /etc/redis.conf
COPY healthcheck.sh /usr/local/bin/healthcheck.sh

# Create data directory
RUN mkdir -p /data && chown redis:redis /data \
    && chmod +x /usr/local/bin/healthcheck.sh

USER redis

EXPOSE 6379

CMD ["redis-server", "/etc/redis.conf"]
