---
name: api-platform:audit
description: Audite un projet API Platform existant et produit un rapport de bonnes pratiques, performances et sécurité
model: sonnet
allowed-tools: [Read, Grep, Glob, Bash]
version: 1.0.0
license: MIT
---

# API Platform Audit

Audite un projet API Platform existant pour vérifier les bonnes pratiques, la sécurité, les performances et la cohérence de configuration.

## Instructions à Exécuter

**IMPORTANT : Exécute ce workflow étape par étape :**

### 1. Détecter la configuration API Platform

- Vérifier `composer.json` pour la version d'API Platform installée
- Chercher la configuration dans `config/packages/api_platform.yaml` ou `config/packages/api_platform.php`
- Identifier le format de configuration utilisé (attributs PHP, YAML, XML)

### 2. Inventorier les resources API

- Chercher tous les fichiers avec `#[ApiResource]` via Grep
- Chercher les configurations YAML/XML si utilisées
- Pour chaque resource, noter :
  - Opérations exposées
  - Groupes de sérialisation
  - Filtres configurés
  - Configuration de sécurité
  - State providers/processors personnalisés

### 3. Audit des bonnes pratiques

Vérifier pour chaque resource :

**Configuration :**
- [ ] Opérations explicitement déclarées (pas les opérations par défaut implicites)
- [ ] Groupes de sérialisation configurés (read/write séparés)
- [ ] Pagination configurée (pas de pagination désactivée sans raison)
- [ ] Format de réponse cohérent (JSON-LD, JSON:API, HAL)

**Sécurité :**
- [ ] Attribut `security` défini sur les opérations sensibles (POST, PUT, PATCH, DELETE)
- [ ] Pas d'exposition de données sensibles (mots de passe, tokens, données internes)
- [ ] Validation configurée sur les opérations d'écriture
- [ ] CORS correctement configuré (`nelmio_cors`)
- [ ] Rate limiting si exposé publiquement

**Performances :**
- [ ] HTTP caching configuré (Cache-Control, ETag, Vary)
- [ ] Eager loading pour éviter les requêtes N+1 (forceEager, fetchEager)
- [ ] Index Doctrine sur les colonnes filtrées/triées
- [ ] Pagination activée avec une taille de page raisonnable (pas de `pagination_enabled: false` sur de grandes collections)
- [ ] Groupes de sérialisation limitant les données retournées

**Architecture :**
- [ ] DTOs utilisés quand la représentation diffère de l'entité
- [ ] State Providers/Processors pour la logique métier complexe
- [ ] Pas de logique métier dans les entités Doctrine
- [ ] Extensions Doctrine pour le filtrage global (soft delete, tenant)

### 4. Audit de la configuration globale

Vérifier dans `config/packages/api_platform.yaml` :

```yaml
api_platform:
    title: 'Mon API'                    # Titre défini
    version: '1.0.0'                    # Version définie
    formats:                            # Formats explicites
        jsonld: ['application/ld+json']
    defaults:
        pagination_items_per_page: 30   # Pagination par défaut raisonnable
        pagination_client_enabled: true # Contrôle client de la pagination
    mapping:
        paths: ['%kernel.project_dir%/src/Entity']
```

### 5. Audit des tests

- Chercher les tests API dans `tests/` avec Grep
- Vérifier la couverture de tests :
  - [ ] Tests pour chaque resource exposée
  - [ ] Tests de validation
  - [ ] Tests de sécurité (accès non autorisé)
  - [ ] Tests de filtres

### 6. Audit des dépendances

- Vérifier les versions des packages API Platform dans `composer.lock`
- Identifier les versions obsolètes
- Vérifier la compatibilité entre packages

### 7. Produire le rapport d'audit

Générer un rapport structuré :

```
## Rapport d'audit API Platform

### Résumé
- Resources API : {nombre}
- Opérations totales : {nombre}
- Score global : {score}/100

### Resources auditées
| Resource | Opérations | Sécurité | Sérialisation | Filtres | Tests |
|----------|-----------|----------|---------------|---------|-------|
| Product  | 6/6       | OK       | OK            | 3       | Oui   |
| User     | 4/6       | WARN     | MISSING       | 0       | Non   |

### Problèmes critiques
1. [CRITIQUE] Resource User sans sécurité sur POST
2. [CRITIQUE] Mot de passe exposé dans la sérialisation User

### Avertissements
1. [WARN] Pas de groupes de sérialisation sur Product
2. [WARN] Pagination désactivée sur LargeCollection

### Recommandations
1. Ajouter security: "is_granted('ROLE_ADMIN')" sur User POST
2. Ajouter #[Groups(['user:read'])] et exclure le mot de passe
3. Configurer le HTTP caching pour les resources en lecture seule

### Couverture de tests
- Resources testées : {x}/{total}
- Tests manquants : {liste}

### Versions
- api-platform/core: {version} (dernière: {dernière})
- symfony/framework-bundle: {version}
```

## Critères d'audit

### Score de sécurité (sur 40)
| Critère | Points |
|---------|--------|
| Security sur opérations d'écriture | 15 |
| Pas de données sensibles exposées | 10 |
| Validation sur les inputs | 10 |
| CORS configuré | 5 |

### Score de qualité (sur 30)
| Critère | Points |
|---------|--------|
| Groupes de sérialisation | 10 |
| Opérations explicites | 10 |
| DTOs quand nécessaire | 5 |
| Documentation OpenAPI | 5 |

### Score de performance (sur 15)
| Critère | Points |
|---------|--------|
| HTTP caching | 5 |
| Pagination configurée | 5 |
| Pas de N+1 queries | 5 |

### Score de tests (sur 15)
| Critère | Points |
|---------|--------|
| Couverture des resources | 10 |
| Tests de sécurité | 5 |

## Notes
- L'audit est en lecture seule, aucune modification n'est effectuée
- Le rapport peut être sauvegardé dans `docs/audit/` si demandé
- Les scores sont indicatifs et basés sur les bonnes pratiques API Platform
- Relancer l'audit après corrections pour vérifier l'amélioration
