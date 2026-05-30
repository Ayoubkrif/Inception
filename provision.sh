#!/bin/sh
set -e

#INFO: Suppression des paquets qui peuvent entrer en conflit
apk del docker-compose docker-doc podman-docker containerd runc 2>/dev/null || true

#INFO: Dépendances de base
apk add make curl git

#INFO: Docker
apk add docker docker-cli docker-cli-compose

#INFO: Docker au démarrage + autoriser vagrant à l'utiliser
rc-update add docker default
service docker start
addgroup vagrant docker
