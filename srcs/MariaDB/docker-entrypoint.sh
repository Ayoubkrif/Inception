#!/bin/bash
set -eo pipefail

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
mysql_log() {
	local type="$1"; shift
	printf '%s [%s] [Entrypoint]: %s\n' "$(date --rfc-3339=seconds)" "$type" "$*"
}
mysql_note()  { mysql_log Note  "$@"; }
mysql_warn()  { mysql_log Warn  "$@" >&2; }
mysql_error() { mysql_log ERROR "$@" >&2; exit 1; }

# ---------------------------------------------------------------------------
# I - Init database directory
# ---------------------------------------------------------------------------
docker_init_database_dir() {
	mysql_note "Initializing database files"
	mariadb-install-db --defaults-file=/dev/null --datadir=/var/lib/mysql --skip-test-db --basedir=/usr --auth-root-authentication-method=normal
	chown -R mysql:mysql /var/lib/mysql
	mysql_note "Database files initialized"
}

# ---------------------------------------------------------------------------
# II - Temporary server (no network, just for provisioning)
# ---------------------------------------------------------------------------
docker_temp_server_start() {
	runuser -u mysql -- mysqld --datadir=/var/lib/mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
	MARIADB_PID=$!
	mysql_note "Waiting for temp server (PID $MARIADB_PID)..."
	local i
	for i in {30..0}; do
		if mysqladmin --socket=/run/mysqld/mysqld.sock ping --silent 2>/dev/null; then
			break
		fi
		sleep 1
	done
	if [ "$i" = 0 ]; then
		mysql_error "Temp server failed to start."
	fi
	mysql_note "Temp server ready"
}

# ---------------------------------------------------------------------------
# III - Provision : root password + database + user + grants
# ---------------------------------------------------------------------------
docker_setup_db() {
	local root_password password
	root_password=$(cat /run/secrets/mariadb_root_password)
	password=$(cat /run/secrets/mariadb_password)

	mysql_note "Provisioning database"
	mysql -u root --password='' --socket=/run/mysqld/mysqld.sock <<-EOSQL
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${root_password}';
		CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
		CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${password}';
		GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
		CREATE USER IF NOT EXISTS 'healthcheck'@'localhost';
		FLUSH PRIVILEGES;
	EOSQL
	mysql_note "Provisioning done"
}

# ---------------------------------------------------------------------------
# IV - Stop temp server
# ---------------------------------------------------------------------------
docker_temp_server_stop() {
	mysql_note "Stopping temp server"
	kill "$MARIADB_PID"
	wait "$MARIADB_PID"
	mysql_note "Temp server stopped"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
_main() {
	if [ ! -d "/var/lib/mysql/mysql" ]; then
		docker_init_database_dir
		docker_temp_server_start
		docker_setup_db
		docker_temp_server_stop
	fi
	mysql_note "Starting MariaDB daemon"
	exec runuser -u mysql -- mysqld --datadir=/var/lib/mysql
}

_main "$@"
