---
name: symfony:console
description: Genere une commande console Symfony avec arguments, options et interaction
model: sonnet
allowed-tools: [AskUserQuestion, Bash, Read, Write, Edit, Grep, Glob]
version: 1.0.0
license: MIT
---

# Symfony Console Command Skill

Genere une commande console Symfony complete avec arguments, options, interaction utilisateur et bonnes pratiques.

## Variables
- **{CommandName}** - Nom de la classe en PascalCase (ex: ImportUsersCommand)
- **{commandName}** - Nom de la commande en kebab-case (ex: app:import-users)
- **{namespace}** - Namespace du projet (defaut: App)

## Outputs
- `src/Command/{CommandName}.php`

## Instructions a Executer

**IMPORTANT : Execute ce workflow etape par etape :**

### 1. Demander le nom de la commande

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quel est le nom de la commande ? (ex: app:import-users)"
  Header: "Commande"
  ```
- Genere CommandName depuis le nom : `app:import-users` -> `ImportUsersCommand`
- Si le nom ne contient pas de `:`, prefixer par `app:`

### 2. Demander la description

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quelle est la description de la commande ?"
  Header: "Description"
  ```

### 3. Demander les arguments et options

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quels arguments et options ? Format: arg:username:required,opt:verbose:v:bool,opt:format:f:string=json (laisser vide si aucun)"
  Header: "Parametres"
  ```
- Parse la liste :
  - `arg:name:required|optional` - Argument positionnel
  - `opt:name:shortcut:type=default` - Option avec shortcut et valeur par defaut

### 4. Demander les options avancees

- Utilise AskUserQuestion (multiSelect: true) pour demander :
  ```
  Question: "Quelles options activer ?"
  Header: "Options"
  Options:
    - "ProgressBar" : "Barre de progression pour les traitements longs"
    - "Table output" : "Affichage tabulaire des resultats"
    - "Lock" : "Empecher l'execution simultanee (LockableTrait)"
    - "Schedulable" : "Attribut AsScheduledTask pour l'execution planifiee"
  ```

### 5. Detecter le namespace du projet

- Lis `composer.json` avec Read
- Extrais le namespace depuis `autoload.psr-4`
- Si non trouve, utilise `App` par defaut

### 6. Generer la commande

- Cree le fichier `src/Command/{CommandName}.php` avec Write
- Structure de classe :

```php
<?php

declare(strict_types=1);

namespace {namespace}\Command;

use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: '{commandName}',
    description: '{description}',
)]
final class {CommandName} extends Command
{
    public function __construct(
        // Injecter les services necessaires
    ) {
        parent::__construct();
    }

    protected function configure(): void
    {
        $this
            // ->addArgument('name', InputArgument::REQUIRED, 'Description')
            // ->addOption('format', 'f', InputOption::VALUE_REQUIRED, 'Output format', 'json')
        ;
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);

        // Logique de la commande

        $io->success('Commande executee avec succes.');

        return Command::SUCCESS;
    }
}
```

**Regles de generation :**
- Classe `final`
- Attribut `#[AsCommand]` avec name et description
- Constructeur avec injection de dependances (services necessaires)
- `parent::__construct()` appele dans le constructeur
- `SymfonyStyle` pour les I/O
- Si ProgressBar : utiliser `$io->createProgressBar($count)` dans execute()
- Si Table : utiliser `$io->table($headers, $rows)` dans execute()
- Si Lock : ajouter `use LockableTrait;` et verifier `$this->lock()` au debut de execute()
- Si Schedulable : ajouter `#[AsScheduledTask('* * * * *')]` apres `#[AsCommand]`
- Retourner `Command::SUCCESS`, `Command::FAILURE` ou `Command::INVALID`

### 7. Afficher le resume

Affiche :
```
Commande {commandName} generee avec succes

Fichiers crees :
- src/Command/{CommandName}.php

Utilisation :
  php bin/console {commandName}
  php bin/console {commandName} --help

Prochaines etapes :
- Implementer la logique dans execute()
- Injecter les services necessaires dans le constructeur
- Ajouter des tests : tests/Command/{CommandName}Test.php
```

## Patterns appliques

### Commande
- Classe `final`, attribut `#[AsCommand]`
- SymfonyStyle pour les I/O console
- Injection de dependances via constructeur
- Codes de retour explicites (SUCCESS, FAILURE, INVALID)
- LockableTrait pour les commandes non-reentrantes
- AsScheduledTask pour la planification via Scheduler

## Notes
- Toujours utiliser `#[AsCommand]` (Symfony 6.1+) plutot que `$defaultName`
- Preferer `SymfonyStyle` a `OutputInterface` directement
- Utiliser `InputArgument::REQUIRED` ou `OPTIONAL` explicitement
- Les options booleennes utilisent `InputOption::VALUE_NONE`
