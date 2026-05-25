#!/bin/sh
set -e

#INFO: Suppression des paquets qui peuvent entrer en conflit
apk del docker-compose docker-doc podman-docker containerd runc 2>/dev/null || true

#INFO: Dépendances de base
apk add make curl git

#INFO: Docker
apk add docker docker-cli docker-cli-compose

#WARN: Clefs SSH pour root
mkdir -p /root/.ssh
cp /shared/vm     /root/.ssh/id_rsa
cp /shared/vm.pub /root/.ssh/id_rsa.pub
chmod 600 /root/.ssh/id_rsa

#INFO: Docker au démarrage + autoriser vagrant à l'utiliser
rc-update add docker default
service docker start
addgroup vagrant docker
