FROM alpine:3.22

#NOTE: Build dependencies
RUN apk add --no-cache git make g++ curl

#NOTE: Clone and compile
RUN git clone --depth=1 --branch inception https://github.com/Ayoubkrif/webserv.git /webserv
RUN cd /webserv && make

#NOTE: Config and static site
COPY webserv.conf /webserv/webserv.conf
COPY site/ /var/www/html/

WORKDIR /webserv

#NOTE: Expose HTTP port
EXPOSE 80

#NOTE: Launch
CMD ["/webserv/WebServ", "/webserv/webserv.conf"]
