---
name: symfony:diagnose
description: Diagnostique les problemes d'une application Symfony — erreurs, performances, configuration
model: opus
allowed-tools: [AskUserQuestion, Bash, Read, Edit, Grep, Glob, Task]
version: 1.0.0
license: MIT
---

# Symfony Diagnose Skill

Diagnostique les problemes d'une application Symfony : erreurs de configuration, problemes de performance, incompatibilites de bundles, deprecations.

## Instructions a Executer

**IMPORTANT : Execute ce workflow etape par etape :**

### 1. Identifier le type de probleme

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quel type de probleme diagnostiquer ?"
  Header: "Diagnostic"
  Options:
    - "Erreur" : "Erreur runtime, exception, page blanche, 500"
    - "Performance" : "Application lente, requetes N+1, cache inefficace"
    - "Configuration" : "Bundle mal configure, service introuvable, route manquante"
    - "Upgrade" : "Deprecations apres mise a jour, incompatibilites"
  ```

### 2. Collecter les informations du projet

Execute en parallele (Task agents) :

**Agent 1 — Environnement :**
- `php -v` (version PHP)
- `php bin/console --version` (version Symfony)
- `php bin/console debug:container --env-vars` (variables d'environnement)
- `composer.json` (dependances et versions)

**Agent 2 — Configuration :**
- `config/packages/*.yaml` (configuration des bundles)
- `config/services.yaml` (services et parametres)
- `.env` et `.env.local` (variables d'environnement)
- `config/routes.yaml` ou `config/routes/` (routing)

**Agent 3 — Logs :**
- `var/log/dev.log` ou `var/log/prod.log` (derniers logs)
- Recherche des exceptions recentes

### 3. Analyser selon le type

#### Erreur
- Identifier l'exception dans les logs
- Rechercher la cause dans le code source
- Verifier la configuration des services impliques
- Proposer un correctif

#### Performance
- `php bin/console debug:router` (nombre de routes)
- Rechercher les requetes N+1 (Doctrine lazy loading)
- Verifier la configuration du cache
- Verifier la configuration de Doctrine (metadata_cache, query_cache, result_cache)
- Analyser les services lourds charges au boot

#### Configuration
- `php bin/console debug:config {bundle}` pour le bundle concerne
- `php bin/console debug:container {service}` pour le service introuvable
- `php bin/console debug:router {route}` pour la route manquante
- Verifier les autowiring et autoconfigure

#### Upgrade
- `php bin/console debug:container --deprecations` (deprecations)
- Analyser le `composer.json` pour les contraintes de version
- Verifier le UPGRADE.md de Symfony
- Identifier les changements breaking

### 4. Produire le rapport

Affiche un rapport structure :

```
## Diagnostic Symfony

### Environnement
- PHP : {version}
- Symfony : {version}
- Env : {dev|prod|test}

### Probleme identifie
{description du probleme}

### Cause probable
{analyse de la cause}

### Solution recommandee
{etapes de resolution}

### Fichiers concernes
- {fichier} : {description du changement}

### Verification
{commande(s) pour verifier la resolution}
```

### 5. Proposer le correctif

- Si le correctif est simple : proposer les modifications de fichiers
- Si le correctif est complexe : proposer un plan d'action etape par etape
- Si le probleme est lie a une dependance : proposer la commande composer appropriee

## Commandes de diagnostic utiles

```bash
# Informations generales
php bin/console about
php bin/console debug:container --show-arguments
php bin/console debug:event-dispatcher

# Routing
php bin/console debug:router
php bin/console router:match /path

# Services
php bin/console debug:container ServiceName
php bin/console debug:autowiring

# Configuration
php bin/console debug:config FrameworkBundle
php bin/console config:dump-reference security

# Doctrine
php bin/console doctrine:schema:validate
php bin/console doctrine:mapping:info

# Cache
php bin/console cache:pool:list
php bin/console cache:clear

# Deprecations
php bin/console debug:container --deprecations
```

## Notes
- Toujours commencer par identifier la version de Symfony et PHP
- Les logs sont la premiere source d'information pour les erreurs
- `debug:container` est l'outil le plus puissant pour les problemes de DI
- Pour les problemes de performance, le Profiler Symfony est indispensable
- Ne jamais modifier les fichiers dans `vendor/` — toujours utiliser les mecanismes d'extension de Symfony
