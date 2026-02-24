---
name: symfony:voter
description: Genere un Voter de securite Symfony pour le controle d'acces granulaire
model: sonnet
allowed-tools: [AskUserQuestion, Bash, Read, Write, Edit, Grep, Glob]
version: 1.0.0
license: MIT
---

# Symfony Voter Skill

Genere un Voter Symfony pour le controle d'acces granulaire sur des objets ou des actions specifiques.

## Variables
- **{VoterName}** - Nom du voter en PascalCase (ex: PostVoter)
- **{subject}** - Type d'objet sur lequel porte le vote
- **{permissions}** - Liste des permissions gerees
- **{namespace}** - Namespace du projet (defaut: App)

## Outputs
- `src/Security/Voter/{VoterName}.php`

## Instructions a Executer

**IMPORTANT : Execute ce workflow etape par etape :**

### 1. Demander le nom du voter

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quel est le nom du voter ? (ex: Post, Comment, Invoice)"
  Header: "Voter"
  ```
- Ajoute le suffixe `Voter` si absent

### 2. Demander le sujet

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Sur quel type d'objet porte le vote ? (ex: App\Entity\Post, App\Entity\Invoice)"
  Header: "Sujet"
  ```

### 3. Demander les permissions

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quelles permissions gerer ? Format: VIEW,EDIT,DELETE,PUBLISH (separees par des virgules)"
  Header: "Permissions"
  ```
- Parse la liste des permissions
- Genere les constantes correspondantes

### 4. Demander la strategie de decision

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Comment gerer un utilisateur non connecte ?"
  Header: "Strategie"
  Options:
    - "Refuser (Recommande)" : "Un utilisateur non connecte est toujours refuse"
    - "Permettre VIEW" : "Permettre la consultation aux anonymes, refuser le reste"
  ```

### 5. Detecter le namespace du projet

- Lis `composer.json` avec Read
- Extrais le namespace depuis `autoload.psr-4`
- Si non trouve, utilise `App` par defaut

### 6. Generer le Voter

- Cree le fichier `src/Security/Voter/{VoterName}.php` avec Write

```php
<?php

declare(strict_types=1);

namespace {namespace}\Security\Voter;

use {namespace}\Entity\{Subject};
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;
use Symfony\Component\Security\Core\Authorization\Voter\Voter;
use Symfony\Component\Security\Core\User\UserInterface;

final class {VoterName} extends Voter
{
    public const string VIEW = 'VIEW';
    public const string EDIT = 'EDIT';
    public const string DELETE = 'DELETE';

    protected function supports(string $attribute, mixed $subject): bool
    {
        return in_array($attribute, [self::VIEW, self::EDIT, self::DELETE], true)
            && $subject instanceof {Subject};
    }

    protected function voteOnAttribute(string $attribute, mixed $subject, TokenInterface $token): bool
    {
        $user = $token->getUser();

        if (!$user instanceof UserInterface) {
            return false;
        }

        /** @var {Subject} $subject */

        return match ($attribute) {
            self::VIEW => $this->canView($subject, $user),
            self::EDIT => $this->canEdit($subject, $user),
            self::DELETE => $this->canDelete($subject, $user),
            default => false,
        };
    }

    private function canView({Subject} $subject, UserInterface $user): bool
    {
        // Tout utilisateur connecte peut voir
        return true;
    }

    private function canEdit({Subject} $subject, UserInterface $user): bool
    {
        // Seul le proprietaire peut editer
        return $subject->getOwner() === $user;
    }

    private function canDelete({Subject} $subject, UserInterface $user): bool
    {
        // Seul le proprietaire peut supprimer
        return $subject->getOwner() === $user;
    }
}
```

**Regles de generation :**
- Classe `final` etendant `Voter`
- Constantes `public const string` pour chaque permission
- `supports()` verifie l'attribut ET le type du sujet
- `voteOnAttribute()` utilise `match` pour dispatcher
- Methodes privees pour chaque permission
- Verification `$user instanceof UserInterface` pour les anonymes
- Type-hint `@var` sur le sujet apres la verification de type

### 7. Afficher le resume

Affiche :
```
Voter {VoterName} genere avec succes

Fichiers crees :
- src/Security/Voter/{VoterName}.php

Permissions :
{liste des permissions}

Utilisation dans un controleur :
  $this->denyAccessUnlessGranted('EDIT', $post);

Utilisation dans Twig :
  {% if is_granted('EDIT', post) %}...{% endif %}

Utilisation avec attribut :
  #[IsGranted('EDIT', subject: 'post')]

Prochaines etapes :
- Implementer la logique de chaque permission
- Ajuster les regles d'acces selon le domaine metier
```

## Patterns appliques

### Voter
- Classe `final`, extends `Voter`
- Constantes pour les permissions (string typed)
- Pattern `match` pour le dispatch
- Methodes privees par permission
- Verification du type utilisateur

## Notes
- Preferer `Voter` a `VoterInterface` pour le typage automatique du sujet
- Les constantes de permission sont reutilisables dans les controleurs et templates
- `match` plutot que `switch` pour le dispatch des permissions
- Toujours verifier `$user instanceof UserInterface` avant de traiter
- Utiliser `#[IsGranted]` dans les controleurs plutot que `denyAccessUnlessGranted()` quand possible
