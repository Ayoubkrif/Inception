# Problèmes réseau inter-containers — Explications

## Fix 1 — php-fpm écoutait sur 127.0.0.1

### Ce qui s'est passé

php-fpm démarrait mais refusait les connexions de NGINX → 502 Bad Gateway.

### Pourquoi

La config par défaut d'Alpine php-fpm contient :
```
listen = 127.0.0.1:9000
```

`127.0.0.1` = loopback = "uniquement depuis ce même container".

NGINX est dans un **container différent**. Depuis son point de vue réseau,
il contacte WordPress via l'IP du container WordPress sur le réseau Docker bridge.
Cette IP n'est pas `127.0.0.1`, donc php-fpm refusait la connexion silencieusement.

### Fix

```
listen = 0.0.0.0:9000
```

`0.0.0.0` = "accepte les connexions depuis n'importe quelle interface",
y compris les autres containers sur le réseau bridge Docker.

---

## Fix 2 — Le healthcheck MariaDB passait trop tôt

### Ce qui s'est passé

WordPress démarrait, tentait de se connecter à MariaDB, et obtenait
`Connection refused (2002)` même si Docker disait MariaDB "healthy".

### Pourquoi

L'entrypoint MariaDB fonctionne en deux phases :

```
Phase 1 — Temp server (provisioning)
  mariadbd --skip-networking   ← pas de TCP, socket Unix uniquement
  → créer la DB, les users, les mots de passe
  → arrêt du temp server

Phase 2 — Vrai server
  mariadbd                     ← TCP port 3306 ouvert
```

Le healthcheck original utilisait le **socket Unix** :
```sh
mariadb-admin --socket=/run/mysqld/mysqld.sock ping
```

Le socket Unix est disponible dès la **Phase 1** (temp server).
Docker déclarait MariaDB "healthy" → WordPress démarrait → essayait TCP 3306
→ le temp server venait d'être tué, le vrai server n'était pas encore lancé
→ Connection refused.

### Fix

```sh
mariadb-admin --host=127.0.0.1 --port=3306 --user=healthcheck ping
```

TCP sur le port 3306 n'est disponible qu'en **Phase 2** (vrai server).
Docker attend maintenant que le vrai server soit prêt avant de lancer WordPress.

---

## Résumé visuel

```
AVANT
──────────────────────────────────────────────────────
MariaDB healthcheck → socket Unix → passe en Phase 1 (trop tôt)
WordPress démarre   → TCP 3306   → Connection refused ✗
php-fpm             → listen 127.0.0.1:9000
NGINX               → fastcgi_pass wordpress:9000 → 502 ✗

APRÈS
──────────────────────────────────────────────────────
MariaDB healthcheck → TCP 3306  → passe seulement en Phase 2 ✓
WordPress démarre   → TCP 3306  → connexion OK ✓
php-fpm             → listen 0.0.0.0:9000
NGINX               → fastcgi_pass wordpress:9000 → 200 ✓
```
