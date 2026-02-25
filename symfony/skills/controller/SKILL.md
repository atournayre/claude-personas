---
name: symfony:controller
description: Genere un controleur Symfony avec routing attributs et bonnes pratiques
model: sonnet
allowed-tools: [AskUserQuestion, Bash, Read, Write, Edit, Grep, Glob]
version: 1.0.0
license: MIT
---

# Symfony Controller Skill

Genere un controleur Symfony avec routing par attributs PHP 8, injection de dependances et bonnes pratiques.

## Variables
- **{ControllerName}** - Nom du controleur en PascalCase (ex: ProductController)
- **{namespace}** - Namespace du projet (defaut: App)
- **{routes}** - Liste des routes/actions

## Outputs
- `src/Controller/{ControllerName}.php`
- `templates/{entity_name}/{action}.html.twig` (si HTML)

## Instructions a Executer

**IMPORTANT : Execute ce workflow etape par etape :**

### 1. Demander le nom du controleur

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quel est le nom du controleur ? (ex: Product, UserProfile)"
  Header: "Controleur"
  ```
- Ajoute le suffixe `Controller` si absent
- Genere le nom en snake_case pour les templates (ex: ProductController -> product)

### 2. Demander le type de controleur

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quel type de controleur ?"
  Header: "Type"
  Options:
    - "CRUD (Recommande)" : "Index, show, new, edit, delete — controleur CRUD complet"
    - "API" : "Controleur API retournant du JSON (JsonResponse)"
    - "Single action" : "Controleur invocable (__invoke) pour une seule action"
    - "Custom" : "Choisir les actions manuellement"
  ```

### 3. Si Custom : demander les actions

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quelles actions ? Format: index:GET:/products,show:GET:/products/{id},create:POST:/products"
  Header: "Actions"
  ```

### 4. Demander les options

- Utilise AskUserQuestion (multiSelect: true) pour demander :
  ```
  Question: "Quelles options activer ?"
  Header: "Options"
  Options:
    - "Templates Twig" : "Generer les templates Twig associes a chaque action"
    - "Form integration" : "Integrer FormType pour new/edit (CRUD)"
    - "Security" : "Ajouter #[IsGranted] sur les actions sensibles"
  ```

### 5. Detecter le namespace du projet

- Lis `composer.json` avec Read
- Extrais le namespace depuis `autoload.psr-4`
- Si non trouve, utilise `App` par defaut

### 6. Generer le controleur

- Cree le fichier `src/Controller/{ControllerName}.php` avec Write

**Controleur CRUD :**
```php
<?php

declare(strict_types=1);

namespace {namespace}\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/{entity_name}')]
final class {ControllerName} extends AbstractController
{
    #[Route('', name: '{entity_name}_index', methods: ['GET'])]
    public function index(): Response
    {
        return $this->render('{entity_name}/index.html.twig', [
            // 'items' => $repository->findAll(),
        ]);
    }

    #[Route('/{id}', name: '{entity_name}_show', methods: ['GET'])]
    public function show(int $id): Response
    {
        return $this->render('{entity_name}/show.html.twig', [
            // 'item' => $repository->find($id),
        ]);
    }

    #[Route('/new', name: '{entity_name}_new', methods: ['GET', 'POST'])]
    public function new(Request $request): Response
    {
        // $form = $this->createForm(EntityType::class);
        // $form->handleRequest($request);

        return $this->render('{entity_name}/new.html.twig', [
            // 'form' => $form,
        ]);
    }

    #[Route('/{id}/edit', name: '{entity_name}_edit', methods: ['GET', 'POST'])]
    public function edit(Request $request, int $id): Response
    {
        return $this->render('{entity_name}/edit.html.twig', [
            // 'form' => $form,
        ]);
    }

    #[Route('/{id}', name: '{entity_name}_delete', methods: ['POST'])]
    public function delete(Request $request, int $id): Response
    {
        // CSRF token validation
        // $entityManager->remove($entity);
        // $entityManager->flush();

        return $this->redirectToRoute('{entity_name}_index');
    }
}
```

**Controleur API :**
```php
#[Route('/api/{entity_name}')]
final class {ControllerName} extends AbstractController
{
    #[Route('', methods: ['GET'])]
    public function list(): JsonResponse { ... }

    #[Route('/{id}', methods: ['GET'])]
    public function show(int $id): JsonResponse { ... }

    #[Route('', methods: ['POST'])]
    public function create(Request $request): JsonResponse { ... }

    #[Route('/{id}', methods: ['PUT'])]
    public function update(Request $request, int $id): JsonResponse { ... }

    #[Route('/{id}', methods: ['DELETE'])]
    public function delete(int $id): JsonResponse { ... }
}
```

**Controleur Single Action :**
```php
#[Route('/{path}', name: '{route_name}', methods: ['GET'])]
final class {ControllerName} extends AbstractController
{
    public function __invoke(): Response
    {
        return $this->render('{template}.html.twig');
    }
}
```

**Regles de generation :**
- Classe `final` etendant `AbstractController`
- Attribut `#[Route]` sur la classe pour le prefixe de route
- Attribut `#[Route]` sur chaque methode avec name et methods
- Si Security : ajouter `#[IsGranted('ROLE_ADMIN')]` sur edit/delete/new
- Si Form integration : injecter EntityManagerInterface et creer/gerer le formulaire
- Methodes GET+POST combinees pour new/edit (affichage + traitement)
- CSRF protection pour delete

### 7. Generer les templates Twig (si demande)

Pour chaque action, creer le template correspondant dans `templates/{entity_name}/`.

### 8. Afficher le resume

Affiche :
```
Controleur {ControllerName} genere avec succes

Fichiers crees :
- src/Controller/{ControllerName}.php
- templates/{entity_name}/index.html.twig (si applicable)
- templates/{entity_name}/show.html.twig (si applicable)
...

Routes :
- GET /{entity_name} -> {entity_name}_index
- GET /{entity_name}/{id} -> {entity_name}_show
...

Prochaines etapes :
- Injecter le repository dans les methodes
- Creer les templates Twig
- Configurer la securite si necessaire
```

## Patterns appliques

### Controleur
- Classe `final`, extends `AbstractController`
- Routing par attributs PHP 8 (`#[Route]`)
- Une responsabilite par action
- Injection de dependances via parametres de methode (autowiring)
- `#[IsGranted]` pour la securite

## Notes
- Toujours utiliser `Symfony\Component\Routing\Attribute\Route` (Symfony 6.2+)
- Preferer les methodes explicites dans `methods: []`
- Nommer toutes les routes avec un prefixe coherent
- Utiliser `AbstractController` (pas `Controller`) pour les helpers Twig/Security
