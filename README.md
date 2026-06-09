*This project has been created as part of the 42 curriculum by aykrifa.*

# Inception

## Description

An introduction to Docker and Vagrant. Inception orchestrates the provisioning of a virtual machine and the deployment of a containerized infrastructure made of 8 services: NGINX, WordPress, MariaDB, Redis, FTP, Adminer, a static website, and a custom service — each running in its own dedicated container, wired together through a private Docker network.

## Architecture

### Network diagram

```
                    Internet
                        │
          ┌─────────────┼─────────────┐
        :443        :21/:21100      :9443
          │              │             │
 ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  VM boundary
          │              │             │
 ┌────────┴──────────────┴─────────────┴──────────────────┐
 │  inception  (bridge network)                           │
 │                                                        │
 │  ┌───────────┐    ┌──────────┐    ┌────────────────┐   │
 │  │   NGINX   │    │   FTP    │    │   Portainer    │   │
 │  │ TLS 1.2/3 │    │  (FTPS)  │    │  (admin UI)    │   │
 │  └─────┬─────┘    └──────────┘    └────────────────┘   │
 │        │                                               │
 │   ┌────┴──┬───────────┐                                │
 │   │ /     │ /about/   │ /adminer/                      │
 │   │       │           │                                │
 │ ┌─┴───┐ ┌───────┐ ┌─────────┐                          │
 │ │  WP │ │WebServ│ │ Adminer │                          │
 │ └─┬───┘ └───────┘ └─────────┘                          │
 │   │                                                    │
 │   ├──────────┐                                         │
 │   │          │                                         │
 │ ┌─┴──────┐ ┌─┴─────┐                                   │
 │ │MariaDB │ │ Redis │                                   │
 │ └────────┘ └───────┘                                   │
 │                                                        │
 └────────────────────────────────────────────────────────┘

Volumes:
  WP  ──── NGINX · WordPress · FTP    (/var/www/html)
  DB  ──── MariaDB                    (/var/lib/mysql)
```

## Instructions

The entire project is driven by GNU Make. Run `make` (or `make list`) to see all available rules.

### Setup — first time

```sh
make Inception_VBox   # provision the VM with Vagrant and open a shell inside it
make provision        # interactive: fill .env, generate secrets, issue the TLS certificate
make compose          # build Docker images and start all containers
```

`make provision` will prompt for:
- MariaDB root password, user password
- WordPress admin user/password, regular user/password
- Portainer admin password
- FTP password

### Daily use

```sh
make ssh              # reconnect to the VM as aykrifa
make compose          # (re)start the stack
make stop             # docker compose down
make ls               # list images, containers and volumes
make logs             # follow logs of all services (Ctrl-C to exit)
```

### Reset

```sh
make re               # wipe containers, images, volumes and data, then recompose
make reprovision      # regenerate .env, secrets and certificate
make destroy          # destroy the VM entirely (Vagrant)
make vm_re            # destroy + rebuild the VM from scratch
```

## Resources

### Documentation

| Topic                          | Reference |
| ------------------------------ | --------- |
| Dockerfile reference           | [docs.docker.com](https://docs.docker.com/reference/dockerfile/) |
| Docker Compose reference       | [docs.docker.com](https://docs.docker.com/reference/compose-file/) |
| Dockerfile best practices      | [openshift/dockerexec](https://github.com/openshift/dockerexec/blob/master/vendor/src/github.com/docker/docker/docs/sources/articles/dockerfile_best-practices.md) |
| NGINX (reference image)        | [nginx/docker-nginx](https://github.com/nginx/docker-nginx/tree/master) |
| NGINX TLS termination          | [docs.nginx.com](https://docs.nginx.com/nginx/admin-guide/security-controls/terminating-ssl-http/) |
| FastCGI proxying (PHP-FPM)     | [DigitalOcean tutorial](https://www.digitalocean.com/community/tutorials/understanding-and-implementing-fastcgi-proxying-in-nginx) |
| WordPress (reference image)    | [docker-library/wordpress](https://github.com/docker-library/wordpress) |
| MariaDB (reference image)      | [MariaDB/mariadb-docker](https://github.com/MariaDB/mariadb-docker/) |
| Redis on Alpine                | [oneuptime.com](https://oneuptime.com/blog/post/2026-03-31-redis-install-alpine-linux/view) |
| vsftpd (peer reference)        | [cuistobal/42_Inception](https://github.com/cuistobal/42_Inception/tree/main/srcs/requirements/bonus/ftp) |
| Alpine Linux                   | [hub.docker.com/_/alpine](https://hub.docker.com/_/alpine) |
| Base image selection           | [Comparison of lightweight Linux distributions](https://en.wikipedia.org/wiki/Comparison_of_lightweight_Linux_distributions) |
| Portainer CE                   | [docs.portainer.io](https://docs.portainer.io/start/install-ce/server/docker/linux) |
| Vagrant (annotated template)   | [gist.github.com/dhimasanb](https://gist.github.com/dhimasanb/826d68cd307c2c194f7ed0b016c2f056) |
| PID 1 in containers            | [docker.com/blog](https://www.docker.com/blog/docker-best-practices-choosing-between-run-cmd-and-entrypoint/) |

### AI usage

This project was entirely developed with AI assistance . AI was used to draft Dockerfiles, entrypoint scripts, Makefile rules, and documentation. All prompts were grounded in the official documentation and tutorials listed above — AI served as an accelerator, not a source of truth. Every generated piece was rigorously read, tested, and audited by the developer before being committed, and validated against the referenced documentation end-to-end inside the VM.

## Project description

Inception is a system administration project centered on Docker containerization. The goal is to build a production-like infrastructure made of 8 services — each in its own container, orchestrated by Docker Compose and driven entirely by a GNU Makefile. The VM itself is provisioned by Vagrant, making the whole stack reproducible from scratch with three commands.

Core concepts covered: container networking, named volumes, TLS termination, environment-based configuration, Docker secrets, and Infrastructure as Code.

### Virtual Machines vs Docker

| Aspect | Virtual Machine | Docker container |
|--------|----------------|-----------------|
| Isolation | Full OS, hypervisor | Shared kernel, namespaces |
| Startup | Minutes | Seconds |
| Resource usage | GBs per VM | MBs per container |
| Use case | Full isolation, legacy systems | Microservices, fast iteration |

This project uses both: a Vagrant VM provides the host environment, and Docker containers handle service isolation within it.

### Secrets vs Environment Variables

| Feature | Environment variable | Docker secret |
|---------|---------------------|---------------|
| Visibility | Exposed in `/proc`, `docker inspect` | Mounted as a file under `/run/secrets/`, never in env |
| At rest | Plaintext in `.env` | Never written to the image or container layer |
| Use case | Non-sensitive config (domain, usernames) | Passwords, TLS certificates, API keys |

**Applied here:** `.env` holds non-sensitive values (domain name, WordPress usernames, DB name). All passwords and the TLS certificate/key are passed as Docker secrets — they never appear in a Dockerfile or in `docker inspect` output.

### Docker Network vs Host Network

| Feature            | Docker network (bridge)                         | Host network                              |
| ------------------ | ----------------------------------------------- | ----------------------------------------- |
| Isolation          | Each container has its own network stack        | Container shares the host's network stack |
| Port exposure      | Explicit `ports:` mapping required              | Any bound port is immediately on the host |
| Security           | Only published ports are reachable from outside | All ports directly exposed                |

**Applied here:** all 8 containers share a single custom bridge network named `inception`. Only three ports are published to the host: `443` (NGINX), `21/21100` (FTP), `9443` (Portainer). Inter-container communication (WordPress → MariaDB, WordPress → Redis, NGINX → WordPress) stays internal.

### Docker Volumes vs Bind Mounts

| Feature                          | Named volume      | Bind mount                   |
| -------------------------------- | ----------------- | ---------------------------- |
| Managed by                       | Docker            | Host filesystem path         |
| Portability                      | Platform-agnostic | Path-dependent               |
| Visibility in `docker volume ls` | Yes               | No                           |

**Applied here:** `WP` and `DB` are declared as named volumes. They are backed by host directories under `$HOME/data` (via `driver: local` + `o: bind`) so data persists across container restarts and is accessible on the host — while remaining Docker-managed and visible in `docker volume ls`.

### Directory structure

```
Inception/
├── Makefile
├── Vagrantfile
├── provision.sh
└── srcs/
    ├── docker-compose.yml
    ├── .env                            (gitignored)
    ├── *.secret                        (gitignored)
    ├── NGINX/
    │   ├── Dockerfile
    │   └── conf.conf
    ├── WordPress/
    │   ├── Dockerfile
    │   └── docker-entrypoint.sh
    ├── MariaDB/
    │   ├── Dockerfile
    │   ├── docker-entrypoint.sh
    │   └── healthcheck.sh
    ├── Redis/                          [bonus]
    │   ├── Dockerfile
    │   ├── redis.conf
    │   └── healthcheck.sh
    ├── FTP/                            [bonus]
    │   ├── Dockerfile
    │   ├── docker-entrypoint.sh
    │   └── vsftpd.conf
    ├── Adminer/                        [bonus]
    │   └── Dockerfile
    ├── WebServ/                        [bonus]
    │   ├── Dockerfile
    │   ├── webserv.conf
    │   └── site/index.html
    └── Portainer/                      [bonus]
        ├── Dockerfile
        └── docker-entrypoint.sh
```
