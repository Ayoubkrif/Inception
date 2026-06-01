#!/bin/sh
set -e

#INFO: Suppression des paquets qui peuvent entrer en conflit
apk del docker-compose docker-doc podman-docker containerd runc 2>/dev/null || true

#INFO: Dépendances de base
apk add make curl git

#INFO: Docker
apk add docker docker-cli docker-cli-compose

#INFO: Docker au démarrage + autoriser aykrifa à l'utiliser
rc-update add docker default
service docker start
addgroup vagrant docker
adduser -D aykrifa
echo "aykrifa ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
addgroup aykrifa docker
addgroup aykrifa vagrant

#INFO: Résolution locale du domaine — aykrifa.42.fr pointe vers localhost dans la VM
echo "127.0.0.1 aykrifa.42.fr" >> /etc/hosts

#INFO: Firefox pour tester le site depuis la VM via X11 forwarding — `make browser`
apk add firefox xauth ttf-dejavu

#HACK: copy vagrant ssh key to aykrifa — même clé privée que vagrant pour `make ssh`
mkdir -p /home/aykrifa/.ssh
cp /home/vagrant/.ssh/authorized_keys /home/aykrifa/.ssh/authorized_keys
chown aykrifa:aykrifa /home/aykrifa
chown -R aykrifa:aykrifa /home/aykrifa/.ssh
chmod 755 /home/aykrifa
chmod 700 /home/aykrifa/.ssh
chmod 600 /home/aykrifa/.ssh/authorized_keys

#INFO: activer PubkeyAuthentication et X11Forwarding dans sshd
sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^X11Forwarding no/X11Forwarding yes/' /etc/ssh/sshd_config
rc-service sshd restart
