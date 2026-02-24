---
name: symfony:event
description: Genere un Event Symfony + EventSubscriber ou EventListener
model: sonnet
allowed-tools: [AskUserQuestion, Bash, Read, Write, Edit, Grep, Glob]
version: 1.0.0
license: MIT
---

# Symfony Event Skill

Genere un Event personnalise et son EventSubscriber ou EventListener selon les bonnes pratiques Symfony.

## Variables
- **{EventName}** - Nom de l'event en PascalCase (ex: OrderPlaced)
- **{HandlerName}** - Nom du subscriber/listener
- **{namespace}** - Namespace du projet (defaut: App)

## Outputs
- `src/Event/{EventName}.php`
- `src/EventSubscriber/{HandlerName}Subscriber.php` ou `src/EventListener/{HandlerName}Listener.php`

## Instructions a Executer

**IMPORTANT : Execute ce workflow etape par etape :**

### 1. Demander le nom de l'event

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quel est le nom de l'evenement ? (ex: OrderPlaced, UserRegistered, InvoiceGenerated)"
  Header: "Event"
  ```
- Stocke dans EventName

### 2. Demander les proprietes de l'event

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quelles donnees porte l'evenement ? Format: order:Order,user:User,amount:float (laisser vide si aucune)"
  Header: "Donnees"
  ```

### 3. Demander le type de handler

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quel type de handler pour cet evenement ?"
  Header: "Handler"
  Options:
    - "EventSubscriber (Recommande)" : "Classe qui s'abonne a un ou plusieurs events via getSubscribedEvents()"
    - "EventListener" : "Classe avec attribut #[AsEventListener] sur la methode de traitement"
  ```

### 4. Demander si l'event est stoppable

- Utilise AskUserQuestion pour demander :
  ```
  Question: "L'evenement peut-il etre stoppe par un listener ?"
  Header: "Stoppable"
  Options:
    - "Non (Recommande)" : "Tous les listeners seront toujours executes"
    - "Oui" : "Un listener peut stopper la propagation (StoppableEventInterface)"
  ```

### 5. Detecter le namespace du projet

- Lis `composer.json` avec Read
- Extrais le namespace depuis `autoload.psr-4`
- Si non trouve, utilise `App` par defaut

### 6. Generer la classe Event

- Cree le fichier `src/Event/{EventName}.php` avec Write

```php
<?php

declare(strict_types=1);

namespace {namespace}\Event;

use Symfony\Contracts\EventDispatcher\Event;

final class {EventName} extends Event
{
    public function __construct(
        private readonly Order $order,
        private readonly User $user,
    ) {
    }

    public function getOrder(): Order
    {
        return $this->order;
    }

    public function getUser(): User
    {
        return $this->user;
    }
}
```

**Si stoppable :**
```php
use Psr\EventDispatcher\StoppableEventInterface;

final class {EventName} extends Event implements StoppableEventInterface
{
    private bool $propagationStopped = false;

    public function isPropagationStopped(): bool
    {
        return $this->propagationStopped;
    }

    public function stopPropagation(): void
    {
        $this->propagationStopped = true;
    }
}
```

**Regles de generation :**
- Classe `final`, extends `Symfony\Contracts\EventDispatcher\Event`
- Proprietes `private readonly` via promoted constructor
- Getters pour chaque propriete
- Pas de setters (event immuable apres creation)

### 7. Generer le handler

**EventSubscriber :**
```php
<?php

declare(strict_types=1);

namespace {namespace}\EventSubscriber;

use {namespace}\Event\{EventName};
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

final class {HandlerName}Subscriber implements EventSubscriberInterface
{
    public static function getSubscribedEvents(): array
    {
        return [
            {EventName}::class => 'on{EventName}',
        ];
    }

    public function on{EventName}({EventName} $event): void
    {
        // Logique de traitement
    }
}
```

**EventListener :**
```php
<?php

declare(strict_types=1);

namespace {namespace}\EventListener;

use {namespace}\Event\{EventName};
use Symfony\Component\EventDispatcher\Attribute\AsEventListener;

final class {HandlerName}Listener
{
    #[AsEventListener]
    public function on{EventName}({EventName} $event): void
    {
        // Logique de traitement
    }
}
```

### 8. Afficher le resume

Affiche :
```
Event {EventName} genere avec succes

Fichiers crees :
- src/Event/{EventName}.php
- src/EventSubscriber/{HandlerName}Subscriber.php (ou Listener)

Dispatch de l'event :
  $this->eventDispatcher->dispatch(new {EventName}($order, $user));

Prochaines etapes :
- Implementer la logique dans le handler
- Injecter les services necessaires
- Dispatcher l'event depuis le service/controleur concerne
```

## Patterns appliques

### Event
- Classe `final`, immuable (readonly properties)
- Extends `Symfony\Contracts\EventDispatcher\Event`
- Constructeur avec promoted properties
- Getters uniquement, pas de setters

### EventSubscriber
- Implements `EventSubscriberInterface`
- `getSubscribedEvents()` retourne un tableau statique
- Peut s'abonner a plusieurs events

### EventListener
- Attribut `#[AsEventListener]` (Symfony 6.2+)
- Une methode par event ecoute

## Notes
- Preferer `EventSubscriber` quand un handler ecoute plusieurs events
- Preferer `EventListener` avec `#[AsEventListener]` pour un handler simple
- Utiliser `Symfony\Contracts\EventDispatcher\Event` (pas `Symfony\Component\EventDispatcher\Event`)
- Les events doivent etre immuables apres creation
- Nommer les events au passe : `OrderPlaced`, `UserRegistered` (pas `OrderPlace`)
