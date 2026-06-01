# SSH avec un user autre que vagrant

Vagrant gère son propre cycle SSH en interne avec le user `vagrant` — il en a besoin pour booter et provisionner la VM. `config.ssh.username` change ce user interne, ce qui casse le boot si le user n'a pas encore de clé SSH configurée (chicken-and-egg).

## Solution

1. Laisser Vagrant booter en `vagrant`
2. Dans `provision.sh`, créer le user et copier la clé autorisée de `vagrant`
3. Se connecter manuellement avec la clé Vagrant

```sh
# provision.sh
adduser -D aykrifa
addgroup aykrifa docker
mkdir -p /home/aykrifa/.ssh
cp /home/vagrant/.ssh/authorized_keys /home/aykrifa/.ssh/
chown -R aykrifa:aykrifa /home/aykrifa/.ssh
chmod 700 /home/aykrifa/.ssh
chmod 600 /home/aykrifa/.ssh/authorized_keys
```

```sh
# connexion
ssh -i .vagrant/machines/default/virtualbox/private_key \
    -p 2222 -o StrictHostKeyChecking=no aykrifa@127.0.0.1
```

Dans ce projet : `make ssh`
