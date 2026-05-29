# MariaDB Healthcheck

## What is tested

Whether the MariaDB server is alive and accepting connections.

## How

`mariadb-admin ping` sends a `COM_PING` packet to the server via the Unix socket.
The server replies with an `OK` packet if it is running and ready. Exit code 0 = healthy, 1 = unhealthy.

The socket (`/run/mysqld/mysqld.sock`) is used instead of TCP because it is available
as soon as the server is ready — no network stack involved, no port scan needed.

A dedicated `healthcheck@localhost` user with no password and no privileges is created
during provisioning. MariaDB requires a valid user entry in `mysql.user` to accept any
connection, even a ping. Without it, the server returns "Access denied" (exit code 1),
making the container appear unhealthy even when the server is fully ready.

## Why

`depends_on: condition: service_healthy` in docker-compose makes WordPress wait for
this check to pass before starting. This replaces a fragile timing loop with a
deterministic signal: WordPress only runs `wp config create` once MariaDB is genuinely
ready to accept connections.

## Parameters (Dockerfile HEALTHCHECK)

| Parameter       | Value | Reason                                                                        |
|-----------------|-------|-------------------------------------------------------------------------------|
| `--interval`    | 1s    | Check every second — detects ready state fast once MariaDB is up              |
| `--timeout`     | 3s    | Fail the check if no reply within 3 seconds                                   |
| `--start-period`| 30s   | Grace period for Docker versions that support it                              |
| `--retries`     | 15    | 15s of tolerance for cold start — MariaDB is ready in ~5s, leaving headroom. Some Docker versions ignore --start-period; high retries ensures the check passes before the container is marked unhealthy |
