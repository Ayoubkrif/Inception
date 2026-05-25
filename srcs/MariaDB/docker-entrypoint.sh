#!/bin/sh

MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mariadb_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/mariadb_password)

#TEST:provisioire, debug
tail -f /dev/null

#NOTE: remplacera le PID 1 par le deamon
# exec mysqld --user=mysql
