*This project has been created as part of the 42 curriculum by aykrifa.*

# Developer documentation

## Prerequisites

The following must be installed on the host machine before anything else:

- [VirtualBox](https://www.virtualbox.org/) — VM hypervisor
- [Vagrant](https://www.vagrantup.com/) — VM provisioner
- GNU Make

Everything else (Docker, docker-compose, WP-CLI, openssl…) is installed automatically inside the VM by `provision.sh`.

---

## Environment setup — from scratch

### 1. Boot the VM

```sh
make Inception_VBox
```

Downloads the Alpine box, creates the VM (1 GB RAM, 1 CPU, IP `192.168.56.10`), runs `provision.sh`, and drops you into a shell as `aykrifa` inside the VM.

### 2. Generate configuration and secrets

Run this **inside the VM** (from `/shared`):

```sh
make provision
```

This runs three steps in sequence:

| Step | What it does |
|------|-------------|
| `make env` | Interactive prompt — writes `srcs/.env` (domain, DB name, WP usernames…) |
| `make secrets` | Interactive prompt — writes password files to `srcs/*.secret` |
| `make certificate` | Generates a self-signed RSA 2048 TLS cert/key pair for `aykrifa.42.fr` |

All generated files are gitignored. They live in `srcs/` inside the VM at `/shared/srcs/` (shared folder).

> To reset and regenerate everything: `make reprovision`

### 3. Build and start the stack

```sh
make compose
```

Creates the host data directories (`$HOME/DB`, `$HOME/WP`), then runs `docker compose up -d`. Images are built from local Dockerfiles — no image is pulled from Docker Hub except the base `alpine:3.22`.

---

## Managing containers and volumes

```sh
make ls               # list images, containers and volumes
make logs             # follow logs of all services
make logs_nginx       # logs for a specific service
make stop             # docker compose down (containers stopped, volumes preserved)
make re               # full wipe: containers + images + volumes + host data, then recompose
make kill             # remove all containers, images and volumes (no recompose)
```

To simulate a container crash and verify restart policies:

```sh
make crash            # sends SIGKILL to all container PIDs from the host
```

---

## Data persistence

| Volume | Host path | Container path | Service |
|--------|-----------|---------------|---------|
| `WP` | `$HOME/WP` | `/var/www/html` | NGINX, WordPress, FTP |
| `DB` | `$HOME/DB` | `/var/lib/mysql` | MariaDB |
| `portainer_data` | Docker-managed | `/data` | Portainer |

`WP` and `DB` are named volumes backed by host directories via `driver: local` + `o: bind`. Data survives `docker compose down` but is wiped by `make re` (which deletes the host directories).

> Secrets (`srcs/*.secret`) are stored in `/home/aykrifa/` inside the VM — **not** in `/shared` — so they survive `vagrant halt` / `vagrant up` cycles but are not synced back to the host.

---

## Secrets and configuration

| File | Location | Content |
|------|----------|---------|
| `.env` | `srcs/.env` | Non-sensitive config (domain, DB name, usernames, volume paths) |
| `*.secret` | `srcs/` | Passwords, TLS certificate and key — mounted as Docker secrets |

Secrets are injected into containers via the `secrets:` key in `docker-compose.yml` and appear at `/run/secrets/<name>` inside the container. They are never set as environment variables and never baked into images.

---

## Portainer

Portainer is available at `https://aykrifa.42.fr:9443` and provides a web UI to manage the Docker environment without touching the CLI. From there you can inspect containers, browse volumes, read logs, restart services, and pull real-time stats.

It is useful during development to quickly check container state or dig into a specific service without running `docker` commands manually.

## Rebuild a single service

```sh
docker compose -f srcs/docker-compose.yml build <ServiceName>
docker compose -f srcs/docker-compose.yml up -d --no-deps <ServiceName>
```

---

## Useful debugging commands

```sh
docker exec -it <container> sh          # shell into a container
docker inspect <container>              # full container metadata
docker compose -f srcs/docker-compose.yml config   # expand compose file with resolved variables
make compose_debug                      # alias for the above
```
