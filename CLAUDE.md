# Inception — 42 Project

## Contexte

Projet Inception de l'école 42. Infrastructure Docker (NGINX, WordPress, MariaDB) via docker-compose.

## Bonus — règle de marquage

Le service webserv est un **bonus** (static website, Chapter VIII). Toute modification apportée à un fichier du repo qui est **en dehors du service bonus lui-même** (`srcs/WebServ/`) doit être encadrée par des commentaires de délimitation :

```
# BONUS
<contenu ajouté pour le bonus>
# END OF BONUS
```

Cela s'applique à tout fichier partagé : `docker-compose.yml`, `Makefile`, configs NGINX, scripts, etc. Sauf mention contraire explicite, cette règle est toujours active.

## Sources & références

- **Interdire** toute ressource issue d'autres projets Inception (repos étudiants, corrections, exemples Inception trouvés en ligne).
- Privilégier dans l'ordre : documentation officielle des providers (Alpine, Debian, MariaDB, WordPress, nginx…), Dockerfiles open source de référence, RFC/specs, tutoriels de production réels.
- L'objectif est une implémentation proche de la réalité — pas un copier-coller de ce que font les autres étudiants 42.

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
- Images basées sur Alpine ou Debian (avant-dernière version stable) : **`alpine:3.22`** (courante = 3.23) ou **`debian:bookworm`** (courante = trixie)
- Pas d'images toutes faites (pas de pull DockerHub sauf alpine/debian)
- Chaque service dans son propre container
- Réseau bridge custom obligatoire
