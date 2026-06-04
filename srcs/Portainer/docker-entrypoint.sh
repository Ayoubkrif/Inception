#!/bin/sh
set -e

PASSWORD_FILE="/run/secrets/portainer_admin_password"

# NOTE: --admin-password-file expects plaintext — Portainer hashes it internally.
# "$@" forwards any extra docker-compose args to the portainer binary.
if [ -f "$PASSWORD_FILE" ]; then
    exec /portainer/portainer --admin-password-file "$PASSWORD_FILE" "$@"
fi

exec /portainer/portainer "$@"
