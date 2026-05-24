# Named Volume vs Bind Mount — Pourquoi ce n'est pas la même chose

## Ce que le sujet interdit

Un **bind mount** au sens Docker, c'est monter directement un path hôte dans un container, sans passer par la couche de gestion des volumes Docker :

```yaml
# BIND MOUNT — interdit par le sujet
services:
  db:
    volumes:
      - /home/user/data/db:/var/lib/mysql   # type: bind implicite
```

ou en syntaxe longue :

```yaml
volumes:
  - type: bind
    source: /home/user/data/db
    target: /var/lib/mysql
```

---

## Ce que je fais

```yaml
# NAMED VOLUME avec driver local
volumes:
  DB:
    name: DB
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${HOST_DATA_PATH}
```

---

## Arguments qui distinguent les deux

### 1. Classification Docker officielle

Docker distingue trois types de stockage : **volumes**, **bind mounts**, et tmpfs.
Ce que je déclare est un **named volume** — il est géré par Docker, pas directement par le filesystem hôte.

Preuve : il apparaît dans `docker volume ls` et `docker volume inspect DB` retourne `"Type": "volume"`, pas `"Type": "bind"`.

### 2. Couche d'abstraction

Un bind mount bypass complètement Docker : le daemon monte directement le répertoire hôte.

Ici, Docker **crée et gère** un objet volume (`DB`). C'est le *driver local* qui, en interne, utilise un bind mount noyau pour implémenter ce volume. L'interface exposée reste celle d'un volume.

C'est comme dire qu'`ext4` "c'est juste des blocs" — techniquement vrai, mais la couche d'abstraction compte.

### 3. Portabilité et réutilisabilité

Un named volume peut être référencé par plusieurs services dans le compose par son nom (`DB`).
Un bind mount est lié à un path hôte fixe et ne peut pas être partagé de cette façon dans la spec Compose.

### 4. Ce que dit la doc Docker

> "If you want a named bind mount, use the local driver with driver_opts.
> This pattern gives a Compose volume a stable name while mapping it to a specific host path."
> — docs.docker.com/reference/compose-file/volumes/

Docker lui-même appelle ça un **"named bind mount"** — une catégorie hybride, différente d'un bind mount pur.

---

## Conclusion

| Critère | Bind mount pur | Mon named volume |
|---|---|---|
| Apparaît dans `docker volume ls` | Non | **Oui** |
| Géré par Docker | Non | **Oui** |
| Syntaxe `type: bind` | Oui | Non |
| Abstraction volume | Non | **Oui** |
| Interdit par le sujet 42 | Oui | **Discutable** |

L'intention du sujet en interdisant les bind mounts est d'éviter de mapper directement le filesystem hôte sans gestion Docker. Ce que je fais passe par la couche volume de Docker, avec un nom, un driver, et une gestion par le daemon — ce qui est exactement ce que les volumes sont censés apporter.
