# php

Skills PHP/Symfony orientés Elegant Objects : génération d'entités, collections, contrats, factories, stories.

## Skills

| Commande | Description |
|----------|-------------|
| `/php:make-all` | Générer tous les fichiers pour une entité complète |
| `/php:make-collection` | Générer une classe Collection typée |
| `/php:make-contracts` | Générer les interfaces de contrats |
| `/php:make-entity` | Générer une entité Doctrine avec repository |
| `/php:make-factory` | Générer une Factory Foundry pour tests |
| `/php:make-invalide` | Générer une classe d'exceptions métier |
| `/php:make-out` | Générer une classe Out (DTO immuable) |
| `/php:make-story` | Générer une Story Foundry pour fixtures |
| `/php:make-urls` | Générer une classe Urls + CQRS Handler |

## Installation

```bash
cp -r php ~/.claude/plugins/php
```

## Dépendances optionnelles

- `symfony` — requis pour les makers Symfony
