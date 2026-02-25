# Référence API Resource - API Platform

## Attribut #[ApiResource]

L'attribut `#[ApiResource]` est le point d'entrée principal pour exposer une classe PHP comme resource API.

### Paramètres principaux

| Paramètre | Type | Description |
|-----------|------|-------------|
| `operations` | `array` | Liste des opérations exposées |
| `normalizationContext` | `array` | Contexte de sérialisation en lecture |
| `denormalizationContext` | `array` | Contexte de sérialisation en écriture |
| `security` | `string` | Expression de sécurité Symfony |
| `securityMessage` | `string` | Message d'erreur si sécurité refusée |
| `securityPostDenormalize` | `string` | Sécurité après désérialisation |
| `provider` | `string` | Classe du State Provider |
| `processor` | `string` | Classe du State Processor |
| `paginationEnabled` | `bool` | Activer/désactiver la pagination |
| `paginationItemsPerPage` | `int` | Nombre d'items par page |
| `order` | `array` | Tri par défaut |
| `input` | `string\|false` | Classe DTO input |
| `output` | `string\|false` | Classe DTO output |
| `uriTemplate` | `string` | Template d'URI personnalisé |
| `routePrefix` | `string` | Préfixe de route |
| `description` | `string` | Description pour OpenAPI |
| `deprecationReason` | `string` | Raison de dépréciation |
| `mercure` | `bool\|array` | Configuration Mercure (temps réel) |
| `shortName` | `string` | Nom court (utilisé dans JSON-LD @type) |

### Opérations disponibles

```php
use ApiPlatform\Metadata\Delete;
use ApiPlatform\Metadata\Get;
use ApiPlatform\Metadata\GetCollection;
use ApiPlatform\Metadata\Patch;
use ApiPlatform\Metadata\Post;
use ApiPlatform\Metadata\Put;
```

Chaque opération accepte les mêmes paramètres que `#[ApiResource]` pour une configuration par opération.

### Exemple complet

```php
<?php

declare(strict_types=1);

namespace App\Entity;

use ApiPlatform\Doctrine\Orm\Filter\DateFilter;
use ApiPlatform\Doctrine\Orm\Filter\OrderFilter;
use ApiPlatform\Doctrine\Orm\Filter\SearchFilter;
use ApiPlatform\Metadata\ApiFilter;
use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Delete;
use ApiPlatform\Metadata\Get;
use ApiPlatform\Metadata\GetCollection;
use ApiPlatform\Metadata\Patch;
use ApiPlatform\Metadata\Post;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Serializer\Attribute\Groups;
use Symfony\Component\Validator\Constraints as Assert;

#[ApiResource(
    operations: [
        new GetCollection(
            paginationItemsPerPage: 20,
            order: ['createdAt' => 'DESC'],
        ),
        new Get(),
        new Post(
            security: "is_granted('ROLE_USER')",
            securityMessage: 'Vous devez être connecté pour créer un produit.',
            validationContext: ['groups' => ['Default', 'product:create']],
        ),
        new Patch(
            security: "is_granted('ROLE_ADMIN') or object.getOwner() == user",
            securityMessage: 'Vous ne pouvez modifier que vos propres produits.',
        ),
        new Delete(
            security: "is_granted('ROLE_ADMIN')",
        ),
    ],
    normalizationContext: ['groups' => ['product:read']],
    denormalizationContext: ['groups' => ['product:write']],
)]
#[ApiFilter(SearchFilter::class, properties: ['name' => 'partial', 'category' => 'exact'])]
#[ApiFilter(OrderFilter::class, properties: ['name', 'price', 'createdAt'])]
#[ApiFilter(DateFilter::class, properties: ['createdAt'])]
#[ORM\Entity]
class Product
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    #[Groups(['product:read'])]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    #[Groups(['product:read', 'product:write'])]
    #[Assert\NotBlank]
    #[Assert\Length(max: 255)]
    private string $name = '';

    #[ORM\Column(type: 'text', nullable: true)]
    #[Groups(['product:read', 'product:write'])]
    private ?string $description = null;

    #[ORM\Column(type: 'decimal', precision: 10, scale: 2)]
    #[Groups(['product:read', 'product:write'])]
    #[Assert\NotBlank]
    #[Assert\Positive]
    private string $price = '0.00';

    #[ORM\Column]
    #[Groups(['product:read'])]
    private \DateTimeImmutable $createdAt;

    // Getters et setters...
}
```

## Opérations multiples sur une même classe

API Platform permet de déclarer plusieurs `#[ApiResource]` sur une même classe pour créer des subresources ou des vues différentes :

```php
#[ApiResource]
#[ApiResource(
    uriTemplate: '/users/{userId}/products',
    uriVariables: [
        'userId' => new Link(
            fromClass: User::class,
            toProperty: 'owner',
        ),
    ],
    operations: [new GetCollection()],
)]
class Product
{
    // ...
}
```

## Formats supportés

| Format | MIME Type | Description |
|--------|----------|-------------|
| JSON-LD | `application/ld+json` | Format par défaut, sémantique web |
| HAL | `application/hal+json` | Hypertext Application Language |
| JSON:API | `application/vnd.api+json` | Spécification JSON:API |
| JSON | `application/json` | JSON simple |
| HTML | `text/html` | Documentation Swagger UI |
| CSV | `text/csv` | Export CSV |
| GraphQL | - | Via le endpoint /graphql |

## Relations

### Exposition des relations

```php
// Relation exposée comme IRI (par défaut)
#[ORM\ManyToOne]
#[Groups(['product:read'])]
private ?Category $category = null;
// Résultat : "category": "/api/categories/1"

// Relation embarquée (embedded)
#[ORM\ManyToOne]
#[Groups(['product:read'])]
private ?Category $category = null;
// Avec Category ayant aussi product:read dans ses groups
// Résultat : "category": { "@id": "/api/categories/1", "name": "..." }
```

### MaxDepth pour éviter les références circulaires

```php
use Symfony\Component\Serializer\Attribute\MaxDepth;

#[MaxDepth(1)]
#[Groups(['product:read'])]
private ?Category $category = null;
```

## Validation

Les contraintes Symfony Validator sont automatiquement appliquées sur les opérations d'écriture :

```php
use Symfony\Component\Validator\Constraints as Assert;

#[Assert\NotBlank]
#[Assert\Length(min: 3, max: 255)]
private string $name = '';

#[Assert\Email]
private string $email = '';

#[Assert\Range(min: 0, max: 1000000)]
private int $price = 0;

#[Assert\Valid] // Valider les objets imbriqués
private Address $address;
```

## Sécurité

### Expressions de sécurité

```php
// Basée sur les rôles
security: "is_granted('ROLE_ADMIN')"

// Basée sur le propriétaire
security: "is_granted('ROLE_USER') and object.getOwner() == user"

// Après désérialisation (accès aux nouvelles valeurs)
securityPostDenormalize: "is_granted('EDIT', object)"

// Voter personnalisé
security: "is_granted('PRODUCT_EDIT', object)"
```

## Pagination

```php
// Désactiver la pagination
#[ApiResource(paginationEnabled: false)]

// Pagination côté client
#[ApiResource(
    paginationClientEnabled: true,
    paginationClientItemsPerPage: true,
)]

// Pagination par curseur
#[ApiResource(
    paginationViaCursor: [
        ['field' => 'id', 'direction' => 'DESC'],
    ],
    paginationPartial: true,
)]
```

## HTTP Caching

```php
#[ApiResource(
    cacheHeaders: [
        'max_age' => 60,
        's_maxage' => 120,
        'vary' => ['Authorization', 'Accept-Language'],
    ],
)]
```

## Mercure (temps réel)

```php
#[ApiResource(mercure: true)]
// Ou avec configuration avancée :
#[ApiResource(mercure: ['private' => true])]
```
