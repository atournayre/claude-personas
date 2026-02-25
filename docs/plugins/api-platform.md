---
title: "api-platform"
description: "Expert API Platform  - resources, providers, processors, filtres, DTOs, tests et audit de projets API Platform"
version: "1.0.0"
---

# api-platform <Badge type="info" text="v1.0.0" />


Expert API Platform couvrant l'ensemble de l'écosystème officiel : resources, state providers/processors, filtres, DTOs, sérialisation, sécurité, tests et audit.

## Skills

| Commande | Description |
|----------|-------------|
| `/api-platform:make-resource` | Générer une API Resource avec opérations, sérialisation et validation |
| `/api-platform:make-filter` | Générer des filtres (search, order, date, range, boolean, custom) |
| `/api-platform:make-provider` | Générer un State Provider pour personnaliser la récupération de données |
| `/api-platform:make-processor` | Générer un State Processor pour personnaliser la persistence |
| `/api-platform:make-dto` | Générer des DTOs input/output avec mapping vers les entités |
| `/api-platform:make-test` | Générer des tests fonctionnels API Platform (ApiTestCase) |
| `/api-platform:audit` | Auditer un projet API Platform (sécurité, performances, bonnes pratiques) |

## Agents

| Agent | Rôle |
|-------|------|
| `api-expert` | Analyse architecture API Platform, conception de resources et providers |
| `reviewer` | Revue de code spécialisée API Platform (sécurité, sérialisation, performances) |

## Couverture de l'écosystème

### Core
- API Resources et opérations (GET, POST, PUT, PATCH, DELETE)
- State Providers et State Processors
- Groupes de sérialisation (normalization/denormalization)
- Validation Symfony intégrée
- Sécurité (expressions, voters)
- Pagination (offset, cursor)
- Subresources et URI variables

### Filtres
- SearchFilter, OrderFilter, DateFilter, RangeFilter
- BooleanFilter, ExistsFilter, NumericFilter
- Filtres personnalisés (AbstractFilter)
- QueryParameter (API Platform 3.3+)

### Formats
- JSON-LD / Hydra
- OpenAPI (Swagger)
- JSON:API, HAL
- GraphQL

### Intégrations
- Doctrine ORM
- Symfony Messenger (CQRS, async)
- HTTP Caching (Varnish)
- Mercure (temps réel)

## Installation

```bash
cp -r api-platform ~/.claude/plugins/api-platform
```

## Dépendances optionnelles

- `php` — Pour les conventions PHP/Symfony (entités, repositories)
- `tester` — Pour les stratégies de test avancées
