---
name: api-platform:make-dto
description: Génère des DTOs (input/output) API Platform avec mapping vers les entités
argument-hint: <nom-resource>
model: sonnet
allowed-tools: [AskUserQuestion, Bash, Read, Write, Edit, Grep, Glob]
version: 1.0.0
license: MIT
---

# API Platform Make DTO

Génère des Data Transfer Objects (DTOs) pour API Platform avec le mapping input/output, les State Providers et Processors associés.

## Variables
- **{ResourceName}** - Nom de la resource en PascalCase
- **{dtoType}** - Type : input, output, ou les deux
- **{namespace}** - Namespace du projet (défaut: App)

## Outputs
- `src/Dto/{ResourceName}Input.php` (si input)
- `src/Dto/{ResourceName}Output.php` (si output)
- `src/State/{ResourceName}Provider.php` (si output DTO)
- `src/State/{ResourceName}Processor.php` (si input DTO)

## Instructions à Exécuter

**IMPORTANT : Exécute ce workflow étape par étape :**

### 1. Identifier la resource cible

- Si `$ARGUMENTS` est fourni, utiliser comme nom de la resource
- Sinon, utiliser AskUserQuestion :
  ```
  Question: "Pour quelle resource créer des DTOs ?"
  Header: "Resource"
  ```
- Vérifier que l'entité existe dans `src/Entity/`
- Lire le fichier pour comprendre les propriétés

### 2. Choisir le type de DTO

- Utiliser AskUserQuestion :
  ```
  Question: "Quel type de DTO créer ?"
  Header: "Type"
  Options:
    - "Input + Output (Recommandé)" : "DTOs distincts pour la lecture et l'écriture"
    - "Output uniquement" : "DTO pour personnaliser la représentation en lecture"
    - "Input uniquement" : "DTO pour valider et transformer les données en écriture"
  ```

### 3. Sélectionner les propriétés

- Lister les propriétés de l'entité
- Pour le DTO output : demander quelles propriétés exposer
- Pour le DTO input : demander quelles propriétés accepter
- Proposer d'ajouter des propriétés calculées (output) ou des champs supplémentaires (input)

### 4. Détecter le namespace du projet

- Lire `composer.json` avec Read
- Extraire le namespace depuis `autoload.psr-4`

### 5. Générer le DTO Output

```php
<?php

declare(strict_types=1);

namespace {namespace}\Dto;

final readonly class {ResourceName}Output
{
    public function __construct(
        public int $id,
        // Propriétés exposées en lecture
        public string $name,
        public string $email,
        // Propriétés calculées
        public string $displayName,
    ) {
    }

    public static function fromEntity({ResourceName} $entity): self
    {
        return new self(
            id: $entity->getId(),
            name: $entity->getName(),
            email: $entity->getEmail(),
            displayName: sprintf('%s (%s)', $entity->getName(), $entity->getEmail()),
        );
    }
}
```

### 6. Générer le DTO Input

```php
<?php

declare(strict_types=1);

namespace {namespace}\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class {ResourceName}Input
{
    public function __construct(
        #[Assert\NotBlank]
        public readonly string $name,

        #[Assert\NotBlank]
        #[Assert\Email]
        public readonly string $email,
    ) {
    }

    public function toEntity(): {ResourceName}
    {
        // Créer l'entité depuis le DTO
    }

    public function updateEntity({ResourceName} $entity): {ResourceName}
    {
        // Mettre à jour l'entité existante
        return $entity;
    }
}
```

### 7. Générer le State Provider (si output DTO)

```php
<?php

declare(strict_types=1);

namespace {namespace}\State;

use ApiPlatform\Metadata\CollectionOperationInterface;
use ApiPlatform\Metadata\Operation;
use ApiPlatform\State\ProviderInterface;
use {namespace}\Dto\{ResourceName}Output;

/**
 * @implements ProviderInterface<{ResourceName}Output>
 */
final readonly class {ResourceName}Provider implements ProviderInterface
{
    public function __construct(
        private ProviderInterface $decorated,
    ) {
    }

    public function provide(Operation $operation, array $uriVariables = [], array $context = []): object|array|null
    {
        $data = $this->decorated->provide($operation, $uriVariables, $context);

        if ($operation instanceof CollectionOperationInterface) {
            $items = [];
            foreach ($data as $entity) {
                $items[] = {ResourceName}Output::fromEntity($entity);
            }
            return $items;
        }

        if (null === $data) {
            return null;
        }

        return {ResourceName}Output::fromEntity($data);
    }
}
```

### 8. Générer le State Processor (si input DTO)

```php
<?php

declare(strict_types=1);

namespace {namespace}\State;

use ApiPlatform\Metadata\Operation;
use ApiPlatform\State\ProcessorInterface;
use {namespace}\Dto\{ResourceName}Input;
use {namespace}\Dto\{ResourceName}Output;

/**
 * @implements ProcessorInterface<{ResourceName}Input, {ResourceName}Output>
 */
final readonly class {ResourceName}Processor implements ProcessorInterface
{
    public function __construct(
        private ProcessorInterface $decorated,
    ) {
    }

    public function process(mixed $data, Operation $operation, array $uriVariables = [], array $context = []): mixed
    {
        /** @var {ResourceName}Input $data */
        $entity = $data->toEntity();

        $result = $this->decorated->process($entity, $operation, $uriVariables, $context);

        return {ResourceName}Output::fromEntity($result);
    }
}
```

### 9. Mettre à jour la resource

Modifier l'attribut `#[ApiResource]` pour utiliser les DTOs :

```php
#[ApiResource(
    operations: [
        new GetCollection(output: {ResourceName}Output::class),
        new Get(output: {ResourceName}Output::class),
        new Post(input: {ResourceName}Input::class, output: {ResourceName}Output::class),
        new Put(input: {ResourceName}Input::class, output: {ResourceName}Output::class),
        new Patch(input: {ResourceName}Input::class, output: {ResourceName}Output::class),
        new Delete(),
    ],
    provider: {ResourceName}Provider::class,
    processor: {ResourceName}Processor::class,
)]
```

### 10. Afficher le résumé

```
DTOs générés pour {ResourceName}

Fichiers créés :
- src/Dto/{ResourceName}Input.php
- src/Dto/{ResourceName}Output.php
- src/State/{ResourceName}Provider.php
- src/State/{ResourceName}Processor.php

Mapping :
- Input : POST/PUT/PATCH → {ResourceName}Input → Entité
- Output : Entité → {ResourceName}Output → GET

Prochaines étapes :
- Compléter la logique toEntity() et updateEntity()
- Ajouter des validations sur le DTO Input
- Tester : /api-platform:make-test {ResourceName}
```

## Patterns appliqués

### DTOs
- Output DTO : `final readonly` avec factory method `fromEntity()`
- Input DTO : `final` avec validation Symfony et méthodes `toEntity()` / `updateEntity()`
- Séparation stricte input/output pour des contrats d'API clairs

### Bonnes pratiques
- Le DTO output est immuable (`readonly`)
- Le DTO input porte la validation
- La transformation entité ↔ DTO est dans le DTO lui-même (méthodes statiques)
- Le provider transforme entité → output DTO
- Le processor transforme input DTO → entité puis entité → output DTO

## Notes
- Les DTOs découplent la représentation API de la structure interne
- Préférer les DTOs quand l'API ne correspond pas 1:1 avec les entités
- Pour les cas simples, les groupes de sérialisation suffisent (pas besoin de DTOs)
- Les DTOs permettent de versionner l'API sans impacter les entités
