#!/bin/sh
mariadb --skip-ssl --protocol=socket \
    -u root -p"$(cat /run/secrets/mariadb_root_password)" \
    -e "SELECT 1 FROM information_schema.ENGINES WHERE engine='InnoDB' AND support IN ('YES','DEFAULT')" \
    >/dev/null 2>&1
