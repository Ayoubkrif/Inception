FROM debian:bookworm
# Install the application dependencies
RUN apt update
RUN apt install -y mariadb-server mariadb-client galera-4
COPY entrypoint.sh .
# First command to launch
ENTRYPOINT ["sh"]
# Arguments
CMD ["entrypoint.sh"]
