# Inception
Inception, simple docker architecture, running on vm built with vagrant

## Piloté par Makefile

Tout le projet se pilote via `make`. C'est le seul point d'entrée à connaître — que ce soit pour gérer la VM, lancer les containers ou nettoyer l'environnement.

```sh
make    # liste toutes les commandes disponibles
```

## Environnement — VM Vagrant

Le projet tourne entièrement dans une machine virtuelle Alpine Linux gérée par **Vagrant**.

### Ce que Vagrant fait automatiquement

| Étape | Détail |
|-------|--------|
| Téléchargement | Récupère la box `generic-x64/alpine319` depuis Vagrant Cloud |
| Installation | Crée et configure la VM dans VirtualBox (1 Go RAM, 1 CPU, IP `192.168.56.10`) |
| Provisionnement | Exécute `provision.sh` en root à l'intérieur de la VM |

### Fichiers de configuration

- **`Vagrantfile`** — déclare la box, le réseau, les dossiers partagés et le port forwarding (443 → 4430). C'est le point d'entrée de toute la VM.
- **`provision.sh`** — script shell exécuté une seule fois au premier `vagrant up`. Il installe Docker, Git, les outils de base, copie les clefs SSH et démarre le service Docker.

### Commandes utiles

```sh
vagrant up          # Crée et provisionne la VM (télécharge la box si absente)
vagrant ssh         # Ouvre un shell dans la VM
vagrant provision   # Rejoue provision.sh sans recréer la VM
vagrant halt        # Éteint la VM
vagrant destroy     # Supprime complètement la VM
```
