# Inception — 42 Project

## Contexte

Projet Inception de l'école 42. Infrastructure Docker (NGINX, WordPress, MariaDB) via docker-compose.

## Règles de collaboration

- L'étudiant veut faire le maximum par lui-même. Ne pas tout implémenter d'un coup.
- Aider ponctuellement, expliquer si demandé, ne pas surguider.

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

## Contraintes du sujet

- Bind mounts interdits — mais implémenter un bind mount à terme pour montrer la différence avec un vrai volume
- Images basées sur Alpine ou Debian (avant-dernière version stable)
- Pas d'images toutes faites (pas de pull DockerHub sauf alpine/debian)
- Chaque service dans son propre container
- Réseau bridge custom obligatoire
