# Redis ↔ WordPress — problèmes rencontrés & fixes

## Contexte

Redis est utilisé comme object cache WordPress via le plugin [redis-cache](https://github.com/rhubarbgroup/redis-cache).  
Le drop-in `object-cache.php` est copié dans `wp-content/` par `wp redis enable` et chargé très tôt au boot de WordPress.

---

## Problème 1 — `token_get_all()` undefined

**Symptôme** : crash WordPress au `wp config set`.

```
PHP Fatal error: Uncaught Error: Call to undefined function token_get_all()
  in WPConfigTransformer.php:300
```

**Cause** : `wp config set` utilise `WPConfigTransformer` pour parser `wp-config.php`.  
Cette lib requiert l'extension PHP `tokenizer`, absente du Dockerfile.

**Fix** : ajouter `php83-tokenizer` dans le `apk add` du Dockerfile WordPress.

---

## Problème 2 — Connection refused au démarrage (boucle de restart)

**Symptôme** : WordPress crashe en boucle avec `Connection refused` vers Redis.

```
RedisException: Connection refused in object-cache.php:737
```

**Cause** : séquence de boot problématique.

1. `wp config create --force` → recrée `wp-config.php` **sans** les constantes Redis.
2. `wp config set WP_REDIS_HOST` → wp-cli charge WordPress pour parser le config.
3. WordPress charge `object-cache.php` (déjà présent dans le volume).
4. Le drop-in tente de se connecter à Redis avec l'host **par défaut** (`127.0.0.1`) car `WP_REDIS_HOST` n'est pas encore dans `wp-config.php`.
5. `127.0.0.1:6379` → connection refused → crash.

**Fix** : supprimer le drop-in **avant** `wp config create --force`.

```sh
rm -f $WP_FILES_LOCATION/wp-content/object-cache.php  # supprime le drop-in
wp config create --force                                # recrée wp-config.php vierge
wp config set WP_REDIS_HOST "Redis"                    # pas de drop-in → pas de tentative de connexion
wp config set WP_REDIS_PORT "6379"
wp redis enable                                        # réinstalle le drop-in avec les bons params
```

---

## Problème 3 — `wp redis` not a registered command (après restart)

**Symptôme** : `Error: 'redis' is not a registered wp command` sur les redémarrages.

**Cause** : `wp plugin install redis-cache` était dans le bloc `if ! wp core is-installed`.  
Si ce bloc est skippé (WP déjà installé) ou interrompu par une erreur antérieure (`set -e`),  
le plugin n'est jamais installé → `wp redis enable` échoue.

**Fix** : sortir `wp plugin install redis-cache --activate` du `if`, le faire tourner à chaque boot.  
`wp plugin install` est idempotent — il ne réinstalle pas si le plugin est déjà présent.

---

## Vérification

```sh
wp redis status --path=$WP_FILES_LOCATION --allow-root
```

Résultat attendu :

```
Status:  Connected
Client:  PhpRedis (v6.3.0)
Drop-in: Valid
```
