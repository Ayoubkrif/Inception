FROM alpine:3.22

RUN apk add --no-cache curl ca-certificates

RUN curl -fsSL https://github.com/portainer/portainer/releases/download/2.39.2/portainer-2.39.2-linux-amd64.tar.gz \
    | tar -xz -C /

EXPOSE 9443

ENTRYPOINT ["/portainer/portainer"]
