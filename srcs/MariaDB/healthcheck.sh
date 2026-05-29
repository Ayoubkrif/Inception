#!/bin/sh
mariadb-admin --socket=/run/mysqld/mysqld.sock --user=healthcheck ping --silent
