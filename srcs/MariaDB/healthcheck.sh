#!/bin/sh
mariadb-admin --host=127.0.0.1 --port=3306 --user=healthcheck ping --silent
