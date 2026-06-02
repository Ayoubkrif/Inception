# WebServ — Inception Service Context

## Role
HTTP server running as a Docker service behind an nginx reverse proxy.
nginx (port 443, TLS) is the **sole entry point** — webserv never handles TLS.

## Network flow
```
client → nginx:443 (TLS) → reverse proxy → webserv:80 (HTTP 1.1)
```

## Protocol
HTTP 1.1 only. No HTTPS, no HTTP/2.

## Allowed base images
- `alpine` (latest)
- `debian` penultimate stable (e.g. `debian:bookworm` if trixie is current)

## Source
```dockerfile
RUN git clone --depth=1 --branch inception https://github.com/Ayoubkrif/webserv.git /webserv
```

## Build
```dockerfile
RUN cd /webserv && make
# produces binary: /webserv/WebServ
```

## Config
`webserv.conf` at repo root. Default serves `GET /` from `/var/www/html`.
Pass config path as first argument:
```dockerfile
CMD ["/webserv/WebServ", "/webserv/webserv.conf"]
```
Adjust `root` and `listen` directives in `webserv.conf` to match your setup.

## Static site
Mount or `COPY` your HTML files into the container at the path set by `root` in `webserv.conf`.
