FROM alpine:3.22
# Install the application dependencies
RUN apk add curl
COPY entrypoint.sh .
# First command to launch
ENTRYPOINT ["sh"]
# Arguments
CMD ["entrypoint.sh"]
