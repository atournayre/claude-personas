---
name: api-platform:make-processor
description: Génère un State Processor API Platform pour personnaliser la persistence des données
argument-hint: <nom-resource>
model: sonnet
allowed-tools: [AskUserQuestion, Bash, Read, Write, Edit, Grep, Glob]
version: 1.0.0
license: MIT
---

# API Platform Make Processor

Génère un State Processor personnalisé pour API Platform. Les processors sont responsables de la persistence des données pour les opérations d'écriture (POST, PUT, PATCH, DELETE).

## Variables
- **{ResourceName}** - Nom de la resource en PascalCase
- **{namespace}** - Namespace du projet (défaut: App)

## Outputs
- `src/State/{ResourceName}Processor.php`

## Instructions à Exécuter

**IMPORTANT : Exécute ce workflow étape par étape :**

### 1. Identifier la resource cible

- Si `$ARGUMENTS` est fourni, utiliser comme nom de la resource
- Sinon, utiliser AskUserQuestion :
  ```
  Question: "Pour quelle resource créer un State Processor ?"
  Header: "Resource"
  ```

### 2. Vérifier la resource existante

- Chercher `src/Entity/{ResourceName}.php` ou `src/ApiResource/{ResourceName}.php` avec Glob
- Si la resource existe, lire le fichier pour comprendre sa structure
- Si la resource n'existe pas, informer l'utilisateur

### 3. Choisir la stratégie de processing

- Utiliser AskUserQuestion :
  ```
  Question: "Quelle stratégie de processing ?"
  Header: "Stratégie"
  Options:
    - "Décorer Doctrine (Recommandé)" : "Ajouter de la logique avant/après la persistence Doctrine"
    - "Custom complet" : "Logique de persistence entièrement personnalisée"
    - "Messenger (async)" : "Dispatcher un message Symfony Messenger au lieu de persister directement"
  ```

### 4. Identifier les opérations à gérer

- Utiliser AskUserQuestion (multiSelect: true) :
  ```
  Question: "Quelles opérations le processor doit-il gérer ?"
  Header: "Opérations"
  Options:
    - "Création (POST)" : "Logique spécifique à la création de la resource"
    - "Mise à jour (PUT/PATCH)" : "Logique spécifique à la modification"
    - "Suppression (DELETE)" : "Logique spécifique à la suppression (soft delete, cascade, etc.)"
  ```

### 5. Détecter le namespace du projet

- Lire `composer.json` avec Read
- Extraire le namespace depuis `autoload.psr-4`

### 6. Générer le State Processor

**Processor décorant Doctrine :**

```php
<?php

declare(strict_types=1);

namespace {namespace}\State;

use ApiPlatform\Metadata\DeleteOperationInterface;
use ApiPlatform\Metadata\Operation;
use ApiPlatform\State\ProcessorInterface;

/**
 * @implements ProcessorInterface<{ResourceName}, {ResourceName}|void>
 */
final readonly class {ResourceName}Processor implements ProcessorInterface
{
    public function __construct(
        private ProcessorInterface $decorated,
    ) {
    }

    public function process(mixed $data, Operation $operation, array $uriVariables = [], array $context = []): mixed
    {
        if ($operation instanceof DeleteOperationInterface) {
            return $this->processDelete($data, $operation, $uriVariables, $context);
        }

        // Logique avant persistence
        $this->beforePersist($data, $operation, $context);

        $result = $this->decorated->process($data, $operation, $uriVariables, $context);

        // Logique après persistence
        $this->afterPersist($result, $operation, $context);

        return $result;
    }

    private function beforePersist(mixed $data, Operation $operation, array $context): void
    {
        // Ex: enrichir les données, valider, auditer
    }

    private function afterPersist(mixed $result, Operation $operation, array $context): void
    {
        // Ex: envoyer un email, dispatcher un event, invalider un cache
    }

    private function processDelete(mixed $data, Operation $operation, array $uriVariables, array $context): void
    {
        // Ex: soft delete au lieu de suppression physique
        $this->decorated->process($data, $operation, $uriVariables, $context);
    }
}
```

**Processor avec Messenger :**

```php
<?php

declare(strict_types=1);

namespace {namespace}\State;

use ApiPlatform\Metadata\Operation;
use ApiPlatform\State\ProcessorInterface;
use Symfony\Component\Messenger\MessageBusInterface;
use {namespace}\Message\Create{ResourceName}Message;

/**
 * @implements ProcessorInterface<{ResourceName}, {ResourceName}>
 */
final readonly class {ResourceName}Processor implements ProcessorInterface
{
    public function __construct(
        private MessageBusInterface $messageBus,
    ) {
    }

    public function process(mixed $data, Operation $operation, array $uriVariables = [], array $context = []): mixed
    {
        $this->messageBus->dispatch(new Create{ResourceName}Message($data));

        return $data;
    }
}
```

### 7. Configurer le service (si décoration Doctrine)

- Informer de la configuration :

```yaml
# config/services.yaml
services:
    App\State\{ResourceName}Processor:
        arguments:
            $decorated: '@api_platform.doctrine.orm.state.persist_processor'
        # Pour la suppression :
        # $decorated: '@api_platform.doctrine.orm.state.remove_processor'
```

### 8. Mettre à jour la resource

- Ajouter le processor dans l'attribut `#[ApiResource]` :

```php
#[ApiResource(
    processor: {ResourceName}Processor::class,
)]
```

### 9. Afficher le résumé

```
State Processor {ResourceName}Processor généré

Fichiers créés :
- src/State/{ResourceName}Processor.php

Configuration requise :
- Vérifier config/services.yaml (si décoration Doctrine)

Prochaines étapes :
- Implémenter la logique métier dans process()
- Créer le provider associé : /api-platform:make-provider {ResourceName}
- Tester : /api-platform:make-test {ResourceName}
```

## Patterns appliqués

### State Processor
- Implémente `ProcessorInterface`
- Classe `final readonly`
- Séparation create/update/delete dans des méthodes dédiées
- Hook beforePersist/afterPersist pour la logique métier

### Bonnes pratiques
- Décorer le processor Doctrine pour garder la persistence automatique
- Utiliser `DeleteOperationInterface` pour détecter les suppressions
- Dispatcher des events/messages pour les effets de bord (emails, notifications)
- Ne pas mélanger logique métier et persistence dans le même processor

## Notes
- Le processor est appelé pour les opérations POST, PUT, PATCH, DELETE
- Pour la lecture (GET), utiliser un State Provider
- Un processor peut retourner un objet différent de celui reçu (transformation)
- Pour le traitement asynchrone, combiner avec Symfony Messenger
