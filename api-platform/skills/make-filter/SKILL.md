---
name: api-platform:make-filter
description: Génère des filtres API Platform (search, date, range, order, boolean, exists, custom)
argument-hint: <nom-resource>
model: sonnet
allowed-tools: [AskUserQuestion, Bash, Read, Write, Edit, Grep, Glob]
version: 1.0.0
license: MIT
---

# API Platform Make Filter

Génère des filtres pour une resource API Platform : filtres Doctrine intégrés (SearchFilter, DateFilter, RangeFilter, etc.) ou filtres personnalisés.

## Variables
- **{ResourceName}** - Nom de la resource en PascalCase
- **{properties}** - Propriétés à filtrer
- **{filterType}** - Type de filtre (search, date, range, order, boolean, exists, custom)

## Outputs
- Modification de `src/Entity/{ResourceName}.php` (ajout des attributs de filtre)
- `src/Filter/{FilterName}Filter.php` (si filtre custom)

## Instructions à Exécuter

**IMPORTANT : Exécute ce workflow étape par étape :**

### 1. Identifier la resource cible

- Si `$ARGUMENTS` est fourni, utiliser comme nom de la resource
- Sinon, utiliser AskUserQuestion :
  ```
  Question: "Sur quelle resource ajouter des filtres ?"
  Header: "Resource"
  ```
- Vérifier que le fichier `src/Entity/{ResourceName}.php` existe avec Glob
- Lire le fichier avec Read pour comprendre les propriétés disponibles

### 2. Analyser les propriétés de la resource

- Parser les propriétés de la classe (nom, type PHP, type Doctrine)
- Identifier les propriétés candidates pour chaque type de filtre :
  - **string** → SearchFilter (partial, exact, start, end, word_start)
  - **\DateTimeInterface** → DateFilter (before, after, strictly_before, strictly_after)
  - **int, float** → RangeFilter (between, gt, gte, lt, lte)
  - **bool** → BooleanFilter
  - **nullable** → ExistsFilter
  - **relations** → SearchFilter sur les propriétés liées

### 3. Choisir les filtres à ajouter

- Utiliser AskUserQuestion (multiSelect: true) :
  ```
  Question: "Quels types de filtres ajouter ?"
  Header: "Filtres"
  Options:
    - "SearchFilter" : "Recherche textuelle (partial, exact, start, end, word_start)"
    - "OrderFilter" : "Tri sur les propriétés (ASC/DESC)"
    - "DateFilter / RangeFilter / BooleanFilter / ExistsFilter" : "Filtres typés selon les propriétés"
    - "Filtre personnalisé" : "Classe de filtre custom avec logique métier"
  ```

### 4. Configurer chaque filtre

**Pour SearchFilter :**
- Demander la stratégie pour chaque propriété string :
  - `partial` — Recherche contenant (LIKE %value%)
  - `exact` — Correspondance exacte
  - `start` — Commence par (LIKE value%)
  - `end` — Finit par (LIKE %value)
  - `word_start` — Mot commençant par
  - `ipartial` — Recherche partielle insensible à la casse

**Pour OrderFilter :**
- Lister les propriétés triables
- Définir l'ordre par défaut (ASC/DESC)

**Pour DateFilter :**
- Appliquer automatiquement sur les propriétés DateTime

**Pour RangeFilter :**
- Appliquer automatiquement sur les propriétés numériques

### 5. Générer les attributs de filtre

Ajouter les attributs sur la classe de la resource :

```php
use ApiPlatform\Doctrine\Orm\Filter\SearchFilter;
use ApiPlatform\Doctrine\Orm\Filter\OrderFilter;
use ApiPlatform\Doctrine\Orm\Filter\DateFilter;
use ApiPlatform\Doctrine\Orm\Filter\RangeFilter;
use ApiPlatform\Doctrine\Orm\Filter\BooleanFilter;
use ApiPlatform\Doctrine\Orm\Filter\ExistsFilter;
use ApiPlatform\Metadata\ApiFilter;

#[ApiFilter(SearchFilter::class, properties: [
    'name' => 'partial',
    'email' => 'exact',
])]
#[ApiFilter(OrderFilter::class, properties: ['id', 'name', 'createdAt'])]
#[ApiFilter(DateFilter::class, properties: ['createdAt', 'updatedAt'])]
#[ApiFilter(RangeFilter::class, properties: ['price', 'quantity'])]
#[ApiFilter(BooleanFilter::class, properties: ['active'])]
#[ApiFilter(ExistsFilter::class, properties: ['deletedAt'])]
```

### 6. Générer un filtre personnalisé (si demandé)

Créer `src/Filter/{FilterName}Filter.php` :

```php
<?php

declare(strict_types=1);

namespace {namespace}\Filter;

use ApiPlatform\Doctrine\Orm\Filter\AbstractFilter;
use ApiPlatform\Doctrine\Orm\Util\QueryNameGeneratorInterface;
use ApiPlatform\Metadata\Operation;
use Doctrine\ORM\QueryBuilder;

final class {FilterName}Filter extends AbstractFilter
{
    protected function filterProperty(
        string $property,
        mixed $value,
        QueryBuilder $queryBuilder,
        QueryNameGeneratorInterface $queryNameGenerator,
        string $resourceClass,
        ?Operation $operation = null,
        array $context = [],
    ): void {
        if ('customProperty' !== $property) {
            return;
        }

        $parameterName = $queryNameGenerator->generateParameterName($property);
        $queryBuilder
            ->andWhere(sprintf('o.%s = :%s', $property, $parameterName))
            ->setParameter($parameterName, $value);
    }

    public function getDescription(string $resourceClass): array
    {
        return [
            'customProperty' => [
                'property' => 'customProperty',
                'type' => 'string',
                'required' => false,
                'description' => 'Description du filtre personnalisé',
                'openapi' => [
                    'description' => 'Description pour OpenAPI',
                ],
            ],
        ];
    }
}
```

### 7. Afficher le résumé

```
Filtres ajoutés à {ResourceName}

Filtres configurés :
- SearchFilter : name (partial), email (exact)
- OrderFilter : id, name, createdAt
- DateFilter : createdAt, updatedAt

Exemples de requêtes :
- GET /api/{resources}?name=foo         (recherche partielle)
- GET /api/{resources}?order[name]=asc  (tri)
- GET /api/{resources}?createdAt[after]=2024-01-01 (date)

Documentation automatique :
- Les filtres apparaissent dans OpenAPI/Swagger
- Les filtres sont documentés dans les réponses Hydra

Prochaines étapes :
- Tester les filtres : /api-platform:make-test {ResourceName}
- Ajouter des filtres personnalisés : /api-platform:make-filter {ResourceName}
```

## Filtres disponibles

### Filtres Doctrine ORM intégrés
| Filtre | Usage | Paramètres |
|--------|-------|------------|
| SearchFilter | Recherche textuelle | exact, partial, start, end, word_start, ipartial |
| OrderFilter | Tri | ASC, DESC |
| DateFilter | Dates | before, after, strictly_before, strictly_after |
| RangeFilter | Intervalles numériques | between, gt, gte, lt, lte |
| BooleanFilter | Booléens | true, false, 1, 0 |
| ExistsFilter | Nullabilité | true, false |
| NumericFilter | Valeurs numériques exactes | valeur exacte |

### QueryParameter (API Platform 3.3+)
- Alternative moderne aux filtres via `#[QueryParameter]`
- Plus flexible, supporte les expressions de sécurité
- Utilisable avec ou sans Doctrine

## Notes
- Les filtres Doctrine ne fonctionnent qu'avec le state provider Doctrine
- Pour les DTOs avec providers personnalisés, implémenter le filtrage dans le provider
- Penser à indexer les colonnes filtrées en base de données
- Les filtres sont automatiquement documentés dans OpenAPI
