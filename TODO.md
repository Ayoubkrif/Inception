# TODO — Inception

## MD files (sujet Chapter VI & VII)

### README.md

Exigences du sujet (Chapter VI) — à écrire **en anglais** :

- [x] Première ligne : italique, exactement : *This project has been created as part of the 42 curriculum by aykrifa.*
- [x] Section **Description** — but du projet + vue d'ensemble
- [x] Section **Instructions** — compilation / installation / exécution
- [x] Section **Resources** — références (doc, articles, tutos) + description de l'usage de l'IA (quelles tâches, quelles parties du projet)
- [x] Section **Project description** — usage de Docker, sources incluses, principaux choix de design, et les quatre comparaisons obligatoires :
  - [x] Virtual Machines vs Docker
  - [x] Secrets vs Environment Variables
  - [x] Docker Network vs Host Network
  - [x] Docker Volumes vs Bind Mounts

> README actuel : en français, pas conforme. À réécrire from scratch en anglais.

---

### USER_DOC.md

Fichier à créer (Chapter VII) — documentation utilisateur/admin :

- [x] Quels services sont fournis par le stack (NGINX, WordPress, MariaDB)
- [x] Comment démarrer et arrêter le projet
- [x] Comment accéder au site web et au panneau d'administration
- [x] Où trouver et gérer les credentials
- [x] Comment vérifier que les services tournent correctement

---

### DEV_DOC.md

Fichier à créer (Chapter VII) — documentation développeur :

- [x] Mise en place de l'environnement from scratch (prérequis, fichiers de config, secrets)
- [x] Build et lancement du projet via Makefile + Docker Compose
- [x] Commandes utiles pour gérer les containers et les volumes
- [x] Où les données du projet sont stockées et comment elles persistent

---

### Nettoyage MD (à faire après que les 3 fichiers ci-dessus soient complétés)

MD actuels à garder jusqu'à la fin (source de doc) puis à supprimer :

- `BIND_MOUNT.md`
- `bug_cookie_empty_value.md`
- `ssh.md`
- `SSH_USER.md`
- `wp_php.md`
- `srcs/NETWORKING.md` (supprimé du repo selon git status)
