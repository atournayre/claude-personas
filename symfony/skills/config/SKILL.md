---
name: symfony:config
description: Assistant de configuration de bundles Symfony — aide a configurer n'importe quel bundle officiel
model: opus
allowed-tools: [AskUserQuestion, Bash, Read, Write, Edit, Grep, Glob, WebSearch, WebFetch]
version: 1.0.0
license: MIT
---

# Symfony Config Skill

Assistant expert pour la configuration de n'importe quel bundle officiel de l'ecosysteme Symfony. Analyse le projet, identifie les besoins et propose la configuration optimale.

## Instructions a Executer

**IMPORTANT : Execute ce workflow etape par etape :**

### 1. Identifier le bundle a configurer

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quel bundle ou composant Symfony configurer ?"
  Header: "Bundle"
  Options:
    - "Security" : "Authentification, firewalls, access control, providers"
    - "Doctrine" : "ORM, DBAL, migrations, types, cache"
    - "Messenger" : "Transports, routing, middleware, retry, failed"
    - "Mailer" : "SMTP, DSN, enveloppes, transport"
  ```
- Si "Autre" : demander le nom du bundle/composant

### 2. Analyser le projet

- Lis `composer.json` pour verifier que le bundle est installe
- Lis `config/packages/` pour la configuration existante
- Lis `.env` et `.env.local` pour les variables d'environnement
- Identifie la version de Symfony (`composer.json` -> `symfony/framework-bundle`)

### 3. Analyser la configuration actuelle

- Lis le fichier de configuration existant dans `config/packages/`
- Identifie ce qui est deja configure
- Identifie ce qui manque ou ce qui pourrait etre ameliore

### 4. Proposer la configuration

- Presente la configuration recommandee
- Explique chaque option importante
- Signale les options de securite critiques
- Indique les variables d'environnement necessaires

### 5. Appliquer la configuration

- Utilise AskUserQuestion pour confirmer :
  ```
  Question: "Appliquer cette configuration ?"
  Header: "Confirmer"
  Options:
    - "Oui" : "Appliquer la configuration proposee"
    - "Modifier" : "Modifier la configuration avant d'appliquer"
    - "Non" : "Annuler"
  ```
- Si oui : ecrire/modifier les fichiers de configuration
- Si modifier : ajuster selon les demandes

### 6. Verifier la configuration

- Execute `php bin/console debug:config {bundle}` si possible
- Execute `php bin/console lint:yaml config/` pour valider la syntaxe
- Signale les erreurs ou warnings

### 7. Afficher le resume

Affiche :
```
Configuration {bundle} mise a jour

Fichiers modifies :
- config/packages/{bundle}.yaml
- .env (si variables ajoutees)

Configuration appliquee :
{resume des options configurees}

Commandes utiles :
- php bin/console debug:config {bundle}
- php bin/console config:dump-reference {bundle}

Prochaines etapes :
{recommandations specifiques au bundle}
```

## Couverture des bundles

Cette skill couvre l'ensemble des bundles officiels Symfony, notamment :

### Framework Core
- `framework-bundle` : kernel, router, cache, session, serializer, validator, property-access, http-client, assets
- `routing` : chargement des routes, locale, requirements
- `cache` : pools, adapters, tags

### Security
- `security-bundle` : firewalls, providers, authenticators, access_control, role_hierarchy, remember_me, login_throttling

### Doctrine
- `doctrine-bundle` : DBAL connections, ORM entity managers, DQL, types, cache, second-level cache
- `doctrine-migrations-bundle` : migration paths, storage, versioning

### Messenger
- `messenger` : transports (doctrine, amqp, redis), routing, middleware, retry_strategy, failure_transport

### Mailer & Notifier
- `mailer` : DSN, enveloppes, headers
- `notifier` : channels (email, sms, chat, browser), DSN par channel

### Twig
- `twig-bundle` : paths, globals, form themes, debug
- `twig-extra-bundle` : intl, markdown, html, inky

### Monolog
- `monolog-bundle` : handlers, channels, processors, formatters

### Autres bundles courants
- `validator` : auto_mapping, enable_attributes
- `serializer` : name_converter, default_context, mapping
- `http-client` : scoped_clients, retry, max_redirects
- `asset-mapper` : importmap, paths, preload
- `scheduler` : schedules, triggers, lock
- `workflow` : state machine, places, transitions, guards
- `rate-limiter` : policies (fixed_window, sliding_window, token_bucket)
- `lock` : stores (flock, redis, doctrine)
- `uid` : default_uuid_version, time_based_uuid_node
- `webhook` : routing_config

## References

- [Bundles Symfony](references/bundles.md) - Reference des configurations des principaux bundles

## Notes
- Toujours verifier la version de Symfony pour les options disponibles
- Certaines options ont change entre Symfony 6.x et 7.x
- Les variables d'environnement sensibles doivent aller dans `.env.local` (pas `.env`)
- Utiliser `debug:config` et `config:dump-reference` pour explorer les options
- Preferer la configuration YAML pour les bundles (convention Symfony)
