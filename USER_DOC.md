*This project has been created as part of the 42 curriculum by aykrifa.*

# User documentation

## Services

| Service   | Role                           | Access                           |
| --------- | ------------------------------ | -------------------------------- |
| NGINX     | Reverse proxy, TLS termination | `https://aykrifa.42.fr`          |
| WordPress | Main website (php-fpm)         | `https://aykrifa.42.fr/`         |
| MariaDB   | WordPress database             | internal only                    |
| Redis     | WordPress object cache         | internal only                    |
| Adminer   | Database management UI         | `https://aykrifa.42.fr/adminer/` |
| WebServ   | Static website                 | `https://aykrifa.42.fr/about/`   |
| FTP       | File access to WordPress files | `ftps://aykrifa.42.fr:21`        |
| Portainer | Docker admin UI                | `https://aykrifa.42.fr:9443`     |

> All HTTPS traffic goes through NGINX on port 443 with TLS 1.2/1.3. The certificate is self-signed — your browser will warn you, click "Advanced" and proceed.

---

## Start and stop

```sh
make compose    # start the full stack
make stop       # stop all containers (data is preserved)
```

---

## Access

### WordPress site
Open `https://aykrifa.42.fr` in your browser.

### WordPress admin panel
`https://aykrifa.42.fr/wp-admin` — log in with the admin credentials set during `make provision`.

### Adminer (database UI)
`https://aykrifa.42.fr/adminer/` — connect with:
- System: `MySQL`
- Server: `MariaDB`
- Username and password: the MariaDB user credentials set during `make provision`

### Static site
`https://aykrifa.42.fr/about/`

### Portainer (Docker admin)
`https://aykrifa.42.fr:9443` — log in with the Portainer admin password set during `make provision`.

### FTP
Connect to `aykrifa.42.fr` on port `21` using FTPS (explicit TLS). The FTP user and password were set during `make provision`.

---

## Credentials

All credentials are stored as secret files in `srcs/` and are never committed to git.

| Secret file | Content |
|-------------|---------|
| `srcs/mariadb_root_password.secret` | MariaDB root password |
| `srcs/mariadb_password.secret` | MariaDB user password |
| `srcs/wp_admin_password.secret` | WordPress admin password |
| `srcs/wp_user_password.secret` | WordPress regular user password |
| `srcs/ftp_password.secret` | FTP password |
| `srcs/portainer_admin_password.secret` | Portainer admin password |
| `srcs/cert.pem.secret` | TLS certificate |
| `srcs/key.pem.secret` | TLS private key |

Non-sensitive configuration (domain name, usernames, database name) is in `srcs/.env`.

---

## Check that services are running

```sh
make ls         # list images, containers and volumes
make logs       # follow logs of all services (Ctrl-C to exit)
```

All containers should show `Up` in `docker ps`. MariaDB and Redis additionally show `(healthy)` once their healthchecks pass (typically within 30 seconds of startup).
