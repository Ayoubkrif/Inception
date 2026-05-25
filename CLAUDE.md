# Inception — 42 Project

## Contexte

Projet Inception de l'école 42. Infrastructure Docker (NGINX, WordPress, MariaDB) via docker-compose.

## Règles de collaboration

- L'étudiant veut faire le maximum par lui-même. Ne pas tout implémenter d'un coup.
- Aider ponctuellement, expliquer si demandé, ne pas surguider.
- Le projet est entièrement piloté par `make`. Quand on documente des commandes (README, commentaires, exemples), toujours préférer la cible `make` correspondante plutôt que la commande brute — **seulement si cette cible existe déjà dans le Makefile**.
- `make` sans argument affiche la liste des cibles via la cible `list` (`.DEFAULT_GOAL := list`).
- **Nomenclature obligatoire** : toute cible qui doit apparaître dans ce listing doit avoir un commentaire `#` inline sur sa ligne de définition :
  ```makefile
  nom_cible: [deps] # description courte affichée dans make list
  ```
  Les cibles sans `#` n'apparaissent pas dans le listing — c'est intentionnel pour les cibles internes.

## Architecture cible

### Services

| Service  | Rôle | Connexions |
|----------|------|------------|
| NGINX    | Reverse proxy, point d'entrée (port 443) | → WordPress, volume WPFiles |
| WordPress | Application web | → MariaDB, volume WPFiles |
| MariaDB  | Base de données WordPress | volume DB |

### Volumes

| Volume  | Contenu |
|---------|---------|
| WPFiles | Fichiers du site WordPress |
| DB      | Base de données MariaDB |

## Environnement

- Le projet tourne via **Vagrant** (VM Alpine)
- Objectif de **reproductibilité maximale** : tout ce qui est manuel doit pouvoir être scripté et rejoué from scratch

## Contraintes du sujet

- Bind mounts interdits — mais implémenter un bind mount à terme pour montrer la différence avec un vrai volume
- Images basées sur Alpine ou Debian (avant-dernière version stable)
- Pas d'images toutes faites (pas de pull DockerHub sauf alpine/debian)
- Chaque service dans son propre container
- Réseau bridge custom obligatoire
