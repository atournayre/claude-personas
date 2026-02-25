---
name: api-platform:make-provider
description: Génère un State Provider API Platform pour personnaliser la récupération de données
argument-hint: <nom-resource>
model: sonnet
allowed-tools: [AskUserQuestion, Bash, Read, Write, Edit, Grep, Glob]
version: 1.0.0
license: MIT
---

# API Platform Make Provider

Génère un State Provider personnalisé pour API Platform. Les providers sont responsables de la récupération des données pour les opérations de lecture (GET, GetCollection).

## Variables
- **{ResourceName}** - Nom de la resource en PascalCase
- **{providerType}** - Type : item, collection, ou les deux
- **{namespace}** - Namespace du projet (défaut: App)

## Outputs
- `src/State/{ResourceName}Provider.php`

## Instructions à Exécuter

**IMPORTANT : Exécute ce workflow étape par étape :**

### 1. Identifier la resource cible

- Si `$ARGUMENTS` est fourni, utiliser comme nom de la resource
- Sinon, utiliser AskUserQuestion :
  ```
  Question: "Pour quelle resource créer un State Provider ?"
  Header: "Resource"
  ```

### 2. Vérifier la resource existante

- Chercher `src/Entity/{ResourceName}.php` ou `src/ApiResource/{ResourceName}.php` avec Glob
- Si la resource existe, lire le fichier pour comprendre sa structure
- Si la resource n'existe pas, informer l'utilisateur et proposer `/api-platform:make-resource`

### 3. Choisir le type de provider

- Utiliser AskUserQuestion :
  ```
  Question: "Quel type de provider créer ?"
  Header: "Type"
  Options:
    - "Complet (Recommandé)" : "Gère à la fois les items (Get) et les collections (GetCollection)"
    - "Item uniquement" : "Gère uniquement la récupération d'un item (Get)"
    - "Collection uniquement" : "Gère uniquement la récupération de collections (GetCollection)"
  ```

### 4. Choisir la source de données

- Utiliser AskUserQuestion :
  ```
  Question: "Quelle est la source de données ?"
  Header: "Source"
  Options:
    - "Doctrine (Recommandé)" : "Décorer le provider Doctrine existant pour ajouter de la logique"
    - "Service externe" : "API tierce, microservice, ou autre source"
    - "Custom" : "Logique métier complexe, agrégation de sources multiples"
  ```

### 5. Détecter le namespace du projet

- Lire `composer.json` avec Read
- Extraire le namespace depuis `autoload.psr-4`
- Si non trouvé, utiliser `App` par défaut

### 6. Générer le State Provider

**Provider décorant Doctrine :**

```php
<?php

declare(strict_types=1);

namespace {namespace}\State;

use ApiPlatform\Metadata\CollectionOperationInterface;
use ApiPlatform\Metadata\Operation;
use ApiPlatform\State\ProviderInterface;

/**
 * @implements ProviderInterface<{ResourceName}>
 */
final readonly class {ResourceName}Provider implements ProviderInterface
{
    public function __construct(
        private ProviderInterface $decorated,
    ) {
    }

    public function provide(Operation $operation, array $uriVariables = [], array $context = []): object|array|null
    {
        if ($operation instanceof CollectionOperationInterface) {
            return $this->provideCollection($operation, $uriVariables, $context);
        }

        return $this->provideItem($operation, $uriVariables, $context);
    }

    private function provideCollection(Operation $operation, array $uriVariables, array $context): iterable
    {
        $items = $this->decorated->provide($operation, $uriVariables, $context);

        // Logique personnalisée sur la collection
        return $items;
    }

    private function provideItem(Operation $operation, array $uriVariables, array $context): ?object
    {
        $item = $this->decorated->provide($operation, $uriVariables, $context);

        // Logique personnalisée sur l'item
        return $item;
    }
}
```

**Provider depuis source externe :**

```php
<?php

declare(strict_types=1);

namespace {namespace}\State;

use ApiPlatform\Metadata\CollectionOperationInterface;
use ApiPlatform\Metadata\Operation;
use ApiPlatform\State\ProviderInterface;
use {namespace}\ApiResource\{ResourceName};

/**
 * @implements ProviderInterface<{ResourceName}>
 */
final readonly class {ResourceName}Provider implements ProviderInterface
{
    public function __construct(
        // Injecter le client HTTP ou le service métier
    ) {
    }

    public function provide(Operation $operation, array $uriVariables = [], array $context = []): object|array|null
    {
        if ($operation instanceof CollectionOperationInterface) {
            // Récupérer et retourner la collection
            return [];
        }

        // Récupérer et retourner un item
        $id = $uriVariables['id'] ?? null;

        return null;
    }
}
```

### 7. Configurer le service (si décoration Doctrine)

- Vérifier si `config/services.yaml` existe
- Informer l'utilisateur de la configuration nécessaire si autoconfiguration Symfony :

```yaml
# config/services.yaml
services:
    App\State\{ResourceName}Provider:
        arguments:
            $decorated: '@api_platform.doctrine.orm.state.item_provider'
        # Ou pour décorer le collection provider :
        # $decorated: '@api_platform.doctrine.orm.state.collection_provider'
```

### 8. Mettre à jour la resource

- Lire la resource avec Read
- Ajouter le provider dans l'attribut `#[ApiResource]` :

```php
#[ApiResource(
    provider: {ResourceName}Provider::class,
)]
```

### 9. Afficher le résumé

```
State Provider {ResourceName}Provider généré

Fichiers créés :
- src/State/{ResourceName}Provider.php

Configuration requise :
- Vérifier config/services.yaml (si décoration Doctrine)

Resource mise à jour :
- provider: {ResourceName}Provider::class ajouté

Prochaines étapes :
- Implémenter la logique métier dans provide()
- Créer le processor associé : /api-platform:make-processor {ResourceName}
- Tester : /api-platform:make-test {ResourceName}
```

## Patterns appliqués

### State Provider
- Implémente `ProviderInterface`
- Classe `final readonly`
- Séparation item/collection dans des méthodes privées
- Décoration du provider Doctrine pour ajouter de la logique

### Bonnes pratiques
- Ne pas dupliquer la logique Doctrine si elle peut être décorée
- Utiliser `CollectionOperationInterface` pour distinguer item/collection
- Typer le template générique `ProviderInterface<ResourceName>`
- Retourner `null` pour un item non trouvé (API Platform gère le 404)

## Notes
- Le provider est appelé pour toutes les opérations de lecture (GET)
- Pour les opérations d'écriture, utiliser un State Processor
- La pagination est gérée automatiquement si le provider retourne un `Paginator`
- Le provider Doctrine peut être décoré pour ajouter des filtres custom, du contrôle d'accès, etc.
