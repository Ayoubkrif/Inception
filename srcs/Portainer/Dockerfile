FROM alpine:3.22

# 1. curl + ca-certificates to fetch the archive over HTTPS
# 2. Download the official Portainer release tarball
# 3. Extract directly into / (creates /portainer/)
RUN apk add --no-cache curl ca-certificates \
    && curl -fsSL https://github.com/portainer/portainer/releases/download/2.39.2/portainer-2.39.2-linux-amd64.tar.gz \
        | tar -xz -C / \
    #HACK: clean for lightweight images
    && apk del curl

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 9443

ENTRYPOINT ["/docker-entrypoint.sh"]
