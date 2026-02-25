---
name: symfony:mailer
description: Genere un email Symfony (TemplatedEmail ou Notification) avec template Twig
model: sonnet
allowed-tools: [AskUserQuestion, Bash, Read, Write, Edit, Grep, Glob]
version: 1.0.0
license: MIT
---

# Symfony Mailer Skill

Genere un service d'envoi d'email Symfony avec TemplatedEmail et template Twig associe, ou une Notification multicanal.

## Variables
- **{EmailName}** - Nom du service en PascalCase (ex: WelcomeEmailSender)
- **{namespace}** - Namespace du projet (defaut: App)

## Outputs
- `src/Mail/{EmailName}.php`
- `templates/emails/{template_name}.html.twig`

## Instructions a Executer

**IMPORTANT : Execute ce workflow etape par etape :**

### 1. Demander le type d'email

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quel type d'email generer ?"
  Header: "Type"
  Options:
    - "TemplatedEmail (Recommande)" : "Email avec template Twig — ideal pour les emails transactionnels"
    - "Notification" : "Notification multicanal (email + browser + chat) via Notifier"
  ```

### 2. Demander le nom

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quel est le nom de l'email ? (ex: WelcomeEmail, OrderConfirmation, PasswordReset)"
  Header: "Email"
  ```
- Stocke dans EmailName

### 3. Demander les variables du template

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quelles variables passer au template ? Format: user:User,order:Order,resetUrl:string (laisser vide si aucune)"
  Header: "Variables"
  ```

### 4. Demander les options

- Utilise AskUserQuestion (multiSelect: true) pour demander :
  ```
  Question: "Quelles options activer ?"
  Header: "Options"
  Options:
    - "Attachments" : "Support des pieces jointes"
    - "Priority" : "Definir la priorite de l'email (high, normal, low)"
    - "Inline CSS" : "Utiliser Twig Inky pour le responsive email"
  ```

### 5. Detecter le namespace du projet

- Lis `composer.json` avec Read
- Extrais le namespace depuis `autoload.psr-4`
- Si non trouve, utilise `App` par defaut

### 6. Generer le service d'email

**TemplatedEmail :**
```php
<?php

declare(strict_types=1);

namespace {namespace}\Mail;

use Symfony\Bridge\Twig\Mime\TemplatedEmail;
use Symfony\Component\Mailer\MailerInterface;
use Symfony\Component\Mime\Address;

final class {EmailName}
{
    public function __construct(
        private readonly MailerInterface $mailer,
        private readonly string $senderEmail,
        private readonly string $senderName,
    ) {
    }

    public function send(User $user): void
    {
        $email = (new TemplatedEmail())
            ->from(new Address($this->senderEmail, $this->senderName))
            ->to(new Address($user->getEmail(), $user->getFullName()))
            ->subject('Bienvenue !')
            ->htmlTemplate('emails/{template_name}.html.twig')
            ->context([
                'user' => $user,
            ])
        ;

        $this->mailer->send($email);
    }
}
```

**Notification :**
```php
<?php

declare(strict_types=1);

namespace {namespace}\Notification;

use Symfony\Component\Notifier\Message\EmailMessage;
use Symfony\Component\Notifier\Notification\EmailNotificationInterface;
use Symfony\Component\Notifier\Notification\Notification;
use Symfony\Component\Notifier\Recipient\EmailRecipientInterface;

final class {EmailName} extends Notification implements EmailNotificationInterface
{
    public function __construct(
        private readonly User $user,
    ) {
        parent::__construct('Subject de la notification');
    }

    public function asEmailMessage(EmailRecipientInterface $recipient, ?string $transport = null): ?EmailMessage
    {
        $email = EmailMessage::fromNotification($this, $recipient);

        // Personnalisation si necessaire

        return $email;
    }

    public function getChannels(EmailRecipientInterface $recipient): array
    {
        return ['email'];
    }
}
```

**Regles de generation :**
- Classe `final`
- Injection de `MailerInterface` pour l'envoi
- `TemplatedEmail` pour les emails avec template Twig
- `Address` avec nom pour l'expediteur et le destinataire
- Les parametres de configuration (sender) injectes via `#[Autowire]` ou bind
- Template Twig dans `templates/emails/`
- Si attachments : utiliser `->attachFromPath()` ou `->attach()`
- Si priority : utiliser `->priority(Email::PRIORITY_HIGH)`

### 7. Generer le template Twig

- Cree le fichier `templates/emails/{template_name}.html.twig` avec Write

```twig
{% extends '@email/default/notification/body.html.twig' %}

{% block content %}
<h1>Bienvenue {{ user.fullName }}</h1>

<p>
    Votre compte a ete cree avec succes.
</p>

{% block action %}
<a href="{{ url('app_dashboard') }}" class="btn btn-primary">
    Acceder a mon compte
</a>
{% endblock %}
{% endblock %}
```

**Si pas d'extension du layout par defaut :**
```twig
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
</head>
<body>
    <h1>Bienvenue {{ user.fullName }}</h1>

    <p>
        Votre compte a ete cree avec succes.
    </p>

    <a href="{{ url('app_dashboard') }}">Acceder a mon compte</a>
</body>
</html>
```

### 8. Afficher le resume

Affiche :
```
Email {EmailName} genere avec succes

Fichiers crees :
- src/Mail/{EmailName}.php
- templates/emails/{template_name}.html.twig

Utilisation :
  $this->{emailName}->send($user);

Configuration (services.yaml) :
  services:
      {namespace}\Mail\{EmailName}:
          arguments:
              $senderEmail: '%env(MAILER_FROM_EMAIL)%'
              $senderName: '%env(MAILER_FROM_NAME)%'

Prochaines etapes :
- Configurer le DSN du mailer dans .env : MAILER_DSN=smtp://...
- Personnaliser le template Twig
- Ajouter les variables d'environnement MAILER_FROM_EMAIL et MAILER_FROM_NAME
```

## Patterns appliques

### Email
- Classe `final` dediee a un type d'email
- `TemplatedEmail` avec template Twig
- `Address` pour expediteur et destinataire
- Configuration externalisee (env vars)

### Notification
- Extends `Notification`, implements `EmailNotificationInterface`
- Multicanal : email, browser, chat, SMS

## Notes
- Preferer `TemplatedEmail` a `Email` pour la separation contenu/presentation
- Utiliser `Address` avec le nom pour un meilleur affichage
- Les parametres d'expediteur doivent etre configurables (pas en dur)
- Tester les emails avec le Web Debug Toolbar ou MailHog/Mailpit
- Pour les emails responsives, utiliser `symfony/twig-extra-bundle` avec Inky
