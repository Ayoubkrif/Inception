FROM alpine:3.22
#NOTE: Install the application dependencies
RUN apk add nginx

#NOTE: Provide conf certificate and key
COPY conf.conf /etc/nginx/nginx.conf

#NOTE: Expose conf listen port
EXPOSE 80

#NOTE: First command to launch
ENTRYPOINT ["nginx"]
#NOTE: Arguments
CMD ["-g", "daemon off;"]
