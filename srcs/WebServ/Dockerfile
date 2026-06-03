FROM alpine:3.22 AS builder

#NOTE: Build dependencies, clone and compile
RUN apk add --no-cache git make g++ curl \
    && git clone --depth=1 --branch inception https://github.com/Ayoubkrif/webserv.git /webserv \
    && cd /webserv && make

#HACK: clean for lightweight images — multi-stage: only the binary survives
FROM alpine:3.22

COPY --from=builder /webserv/WebServ /webserv/WebServ

#NOTE: Config and static site
COPY webserv.conf /webserv/webserv.conf
COPY site/ /var/www/html/

WORKDIR /webserv

#NOTE: Expose HTTP port
EXPOSE 80

#NOTE: Launch
CMD ["/webserv/WebServ", "/webserv/webserv.conf"]
