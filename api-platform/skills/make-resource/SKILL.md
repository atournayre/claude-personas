---
name: api-platform:make-resource
description: Génère une API Resource complète avec attribut #[ApiResource], opérations, groupes de sérialisation et configuration
argument-hint: <nom-entité>
model: sonnet
allowed-tools: [AskUserQuestion, Bash, Read, Write, Edit, Grep, Glob, Skill]
version: 1.0.0
license: MIT
---

# API Platform Make Resource

Génère une API Resource complète pour API Platform : attribut `#[ApiResource]`, opérations CRUD, groupes de sérialisation, validation et configuration associée.

## Variables
- **{ResourceName}** - Nom de la resource en PascalCase (ex: Product)
- **{resourceName}** - Nom en camelCase (ex: product)
- **{namespace}** - Namespace du projet (défaut: App)
- **{properties}** - Liste des propriétés avec types

## Outputs
- `src/Entity/{ResourceName}.php` (ou modification si existant)
- `src/ApiResource/{ResourceName}.php` (si DTO séparé)

## Instructions à Exécuter

**IMPORTANT : Exécute ce workflow étape par étape :**

### 1. Identifier la resource

- Si `$ARGUMENTS` est fourni, utiliser comme nom de la resource
- Sinon, utiliser AskUserQuestion :
  ```
  Question: "Quel est le nom de la resource API à créer ?"
  Header: "Resource"
  ```
- Valider que le nom est en PascalCase
- Stocker dans ResourceName

### 2. Vérifier si l'entité existe déjà

- Utiliser Glob pour chercher `src/Entity/{ResourceName}.php`
- Si l'entité existe :
  - Lire le fichier avec Read
  - Proposer d'ajouter l'attribut `#[ApiResource]` à l'entité existante
- Si l'entité n'existe pas :
  - Demander les propriétés via AskUserQuestion

### 3. Choisir la stratégie d'exposition

- Utiliser AskUserQuestion :
  ```
  Question: "Comment exposer la resource ?"
  Header: "Stratégie"
  Options:
    - "Entité directe (Recommandé)" : "Attribut #[ApiResource] directement sur l'entité Doctrine"
    - "DTO séparé" : "Classe DTO dédiée avec State Provider/Processor personnalisés"
  ```

### 4. Choisir les opérations

- Utiliser AskUserQuestion (multiSelect: true) :
  ```
  Question: "Quelles opérations exposer ?"
  Header: "Opérations"
  Options:
    - "CRUD complet" : "GetCollection, Get, Post, Put, Patch, Delete"
    - "Lecture seule" : "GetCollection et Get uniquement"
    - "Écriture seule" : "Post, Put, Patch, Delete uniquement"
    - "Personnalisé" : "Sélection manuelle des opérations"
  ```

### 5. Configurer les groupes de sérialisation

- Définir les groupes standards :
  - `{resourceName}:read` — Propriétés exposées en lecture (GET)
  - `{resourceName}:write` — Propriétés acceptées en écriture (POST/PUT/PATCH)
  - `{resourceName}:list` — Propriétés pour les collections (GetCollection)
- Appliquer `#[Groups]` sur chaque propriété

### 6. Détecter le namespace du projet

- Lire `composer.json` avec Read
- Extraire le namespace depuis `autoload.psr-4`
- Si non trouvé, utiliser `App` par défaut

### 7. Vérifier qu'API Platform est installé

- Utiliser Grep pour chercher `api-platform` dans `composer.json`
- Si non trouvé :
  - Afficher : `Le package api-platform/core ne semble pas installé.`
  - Afficher : `Installation recommandée : composer require api-platform/api-pack`
  - Continuer la génération

### 8. Générer la resource

**Si entité directe :**

```php
<?php

declare(strict_types=1);

namespace {namespace}\Entity;

use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Delete;
use ApiPlatform\Metadata\Get;
use ApiPlatform\Metadata\GetCollection;
use ApiPlatform\Metadata\Patch;
use ApiPlatform\Metadata\Post;
use ApiPlatform\Metadata\Put;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Serializer\Attribute\Groups;
use Symfony\Component\Validator\Constraints as Assert;

#[ApiResource(
    operations: [
        new GetCollection(),
        new Get(),
        new Post(),
        new Put(),
        new Patch(),
        new Delete(),
    ],
    normalizationContext: ['groups' => ['{resourceName}:read']],
    denormalizationContext: ['groups' => ['{resourceName}:write']],
)]
#[ORM\Entity]
class {ResourceName}
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    #[Groups(['{resourceName}:read'])]
    private ?int $id = null;

    // Propriétés avec #[Groups] et #[Assert\...]
}
```

**Si DTO séparé :**

```php
<?php

declare(strict_types=1);

namespace {namespace}\ApiResource;

use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Get;
use ApiPlatform\Metadata\GetCollection;
use {namespace}\State\{ResourceName}Provider;
use {namespace}\State\{ResourceName}Processor;

#[ApiResource(
    operations: [
        new GetCollection(provider: {ResourceName}Provider::class),
        new Get(provider: {ResourceName}Provider::class),
    ],
    provider: {ResourceName}Provider::class,
    processor: {ResourceName}Processor::class,
)]
class {ResourceName}
{
    public ?int $id = null;
    // Propriétés du DTO
}
```

### 9. Ajouter la validation

- Pour chaque propriété requise, ajouter `#[Assert\NotBlank]`
- Pour les strings avec longueur max, ajouter `#[Assert\Length(max: N)]`
- Pour les emails, ajouter `#[Assert\Email]`
- Pour les propriétés numériques, ajouter `#[Assert\Positive]` si pertinent

### 10. Afficher le résumé

```
Resource API {ResourceName} générée

Fichiers créés/modifiés :
- src/Entity/{ResourceName}.php (ou src/ApiResource/{ResourceName}.php)

Opérations exposées :
- GET    /api/{resource_names}      (collection)
- GET    /api/{resource_names}/{id} (item)
- POST   /api/{resource_names}
- PUT    /api/{resource_names}/{id}
- PATCH  /api/{resource_names}/{id}
- DELETE /api/{resource_names}/{id}

Groupes de sérialisation :
- {resourceName}:read  — Lecture
- {resourceName}:write — Écriture
- {resourceName}:list  — Collection

Prochaines étapes :
- Créer la migration : php bin/console make:migration
- Ajouter des filtres : /api-platform:make-filter {ResourceName}
- Générer les tests : /api-platform:make-test {ResourceName}
- Configurer la sécurité : security: "is_granted('ROLE_USER')"
```

## Patterns appliqués

### Resource
- Attribut `#[ApiResource]` avec opérations explicites
- Groupes de sérialisation read/write/list distincts
- Validation Symfony intégrée
- Opérations typées (Get, Post, etc.) au lieu du tableau operations legacy

### Conventions API Platform
- Utiliser les attributs PHP 8 (pas les annotations)
- Préférer les opérations explicites aux opérations par défaut
- Séparer les groupes de lecture et écriture
- Ajouter la validation sur les opérations d'écriture

## References

- [API Resource](references/api-resource.md) - Documentation détaillée des attributs ApiResource

## Notes
- Utiliser les attributs PHP 8.1+ (pas YAML ni XML)
- Les opérations doivent être explicitement déclarées
- Les groupes de sérialisation sont essentiels pour contrôler l'exposition des données
- Penser à la sécurité : `security` sur les opérations sensibles
