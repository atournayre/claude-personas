---
name: symfony:message
description: Genere un Message Symfony Messenger avec son Handler pour traitement asynchrone
model: sonnet
allowed-tools: [AskUserQuestion, Bash, Read, Write, Edit, Grep, Glob]
version: 1.0.0
license: MIT
---

# Symfony Messenger Skill

Genere un Message et son MessageHandler pour le composant Symfony Messenger (traitement synchrone ou asynchrone).

## Variables
- **{MessageName}** - Nom du message en PascalCase (ex: SendWelcomeEmail)
- **{namespace}** - Namespace du projet (defaut: App)

## Outputs
- `src/Message/{MessageName}.php`
- `src/MessageHandler/{MessageName}Handler.php`

## Instructions a Executer

**IMPORTANT : Execute ce workflow etape par etape :**

### 1. Demander le nom du message

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quel est le nom du message ? (ex: SendWelcomeEmail, ProcessOrder, GenerateReport)"
  Header: "Message"
  ```
- Stocke dans MessageName

### 2. Demander les proprietes du message

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quelles donnees porte le message ? Format: userId:int,email:string,orderId:string (laisser vide si aucune)"
  Header: "Donnees"
  ```

### 3. Demander le type de transport

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quel transport pour ce message ?"
  Header: "Transport"
  Options:
    - "async (Recommande)" : "Traitement asynchrone via le transport par defaut (doctrine, redis, amqp...)"
    - "sync" : "Traitement synchrone immediat"
    - "failed" : "Recu depuis la file d'erreurs (pour retraitement)"
  ```

### 4. Demander les options avancees

- Utilise AskUserQuestion (multiSelect: true) pour demander :
  ```
  Question: "Quelles options activer ?"
  Header: "Options"
  Options:
    - "Stamps" : "Ajouter des stamps personnalises (metadata sur le message)"
    - "Middleware" : "Generer un middleware pour ce type de message"
    - "Retry strategy" : "Configurer la strategie de retry en cas d'echec"
  ```

### 5. Detecter le namespace du projet

- Lis `composer.json` avec Read
- Extrais le namespace depuis `autoload.psr-4`
- Si non trouve, utilise `App` par defaut

### 6. Generer la classe Message

- Cree le fichier `src/Message/{MessageName}.php` avec Write

```php
<?php

declare(strict_types=1);

namespace {namespace}\Message;

final class {MessageName}
{
    public function __construct(
        private readonly int $userId,
        private readonly string $email,
    ) {
    }

    public function getUserId(): int
    {
        return $this->userId;
    }

    public function getEmail(): string
    {
        return $this->email;
    }
}
```

**Regles de generation :**
- Classe `final`, pas d'heritage, pas d'interface
- Proprietes `private readonly` via promoted constructor
- Getters pour chaque propriete
- Pas de setters (message immuable)
- Pas d'injection de services (un message est un simple DTO)
- Les proprietes doivent etre serialisables (scalaires, tableaux, objets simples)

### 7. Generer le MessageHandler

- Cree le fichier `src/MessageHandler/{MessageName}Handler.php` avec Write

```php
<?php

declare(strict_types=1);

namespace {namespace}\MessageHandler;

use {namespace}\Message\{MessageName};
use Symfony\Component\Messenger\Attribute\AsMessageHandler;

#[AsMessageHandler]
final class {MessageName}Handler
{
    public function __construct(
        // Injecter les services necessaires
    ) {
    }

    public function __invoke({MessageName} $message): void
    {
        // Logique de traitement
        // $message->getUserId()
        // $message->getEmail()
    }
}
```

**Regles de generation :**
- Classe `final` avec attribut `#[AsMessageHandler]`
- Methode `__invoke()` avec le message en parametre
- Injection de dependances via constructeur
- Retour `void` par defaut (sauf si query avec retour)

### 8. Generer le middleware (si demande)

- Cree le fichier `src/Messenger/Middleware/{MessageName}Middleware.php` avec Write

```php
<?php

declare(strict_types=1);

namespace {namespace}\Messenger\Middleware;

use Symfony\Component\Messenger\Envelope;
use Symfony\Component\Messenger\Middleware\MiddlewareInterface;
use Symfony\Component\Messenger\Middleware\StackInterface;

final class {MessageName}Middleware implements MiddlewareInterface
{
    public function handle(Envelope $envelope, StackInterface $stack): Envelope
    {
        // Logique avant traitement

        $envelope = $stack->next()->handle($envelope, $stack);

        // Logique apres traitement

        return $envelope;
    }
}
```

### 9. Afficher le resume

Affiche :
```
Message {MessageName} genere avec succes

Fichiers crees :
- src/Message/{MessageName}.php
- src/MessageHandler/{MessageName}Handler.php

Dispatch du message :
  $this->messageBus->dispatch(new {MessageName}($userId, $email));

Configuration du routing (config/packages/messenger.yaml) :
  framework:
      messenger:
          routing:
              '{namespace}\Message\{MessageName}': async

Prochaines etapes :
- Implementer la logique dans le handler
- Configurer le routing dans messenger.yaml
- Lancer le worker : php bin/console messenger:consume async
```

## Patterns appliques

### Message
- Simple DTO immuable (pas de service, pas d'interface)
- Constructeur avec promoted properties readonly
- Serialisable (pas d'objets complexes comme des entites Doctrine)

### Handler
- `#[AsMessageHandler]` attribut (Symfony 6.2+)
- Methode `__invoke()` invocable
- Injection de services via constructeur

### Middleware
- Implements `MiddlewareInterface`
- Pattern decorator : appeler `$stack->next()->handle()`

## Notes
- Un message ne doit contenir que des identifiants (pas des entites Doctrine entieres)
- Preferer `#[AsMessageHandler]` a l'interface `MessageHandlerInterface`
- Le routing (sync/async) se configure dans `messenger.yaml`, pas dans le code
- Utiliser `messenger:consume` pour lancer le worker
- Configurer les retries dans `messenger.yaml` sous `failure_transport`
