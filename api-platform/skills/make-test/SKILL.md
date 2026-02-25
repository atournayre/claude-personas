---
name: api-platform:make-test
description: Génère des tests fonctionnels API Platform (PHPUnit/ApiTestCase) pour une resource
argument-hint: <nom-resource>
model: sonnet
allowed-tools: [AskUserQuestion, Bash, Read, Write, Edit, Grep, Glob]
version: 1.0.0
license: MIT
---

# API Platform Make Test

Génère des tests fonctionnels pour une resource API Platform en utilisant `ApiTestCase` de API Platform et PHPUnit.

## Variables
- **{ResourceName}** - Nom de la resource en PascalCase
- **{namespace}** - Namespace du projet (défaut: App)

## Outputs
- `tests/Api/{ResourceName}Test.php`

## Instructions à Exécuter

**IMPORTANT : Exécute ce workflow étape par étape :**

### 1. Identifier la resource cible

- Si `$ARGUMENTS` est fourni, utiliser comme nom de la resource
- Sinon, utiliser AskUserQuestion :
  ```
  Question: "Pour quelle resource générer les tests ?"
  Header: "Resource"
  ```

### 2. Analyser la resource

- Chercher le fichier de la resource avec Glob (`src/Entity/{ResourceName}.php` ou `src/ApiResource/{ResourceName}.php`)
- Lire le fichier avec Read
- Extraire :
  - Les opérations configurées (GET, POST, PUT, PATCH, DELETE)
  - Les groupes de sérialisation
  - Les contraintes de validation
  - Les filtres configurés
  - La configuration de sécurité
  - Les relations avec d'autres entités

### 3. Détecter la configuration de test

- Vérifier si `ApiTestCase` est disponible (chercher `api-platform/core` dans composer.json)
- Vérifier si une factory Foundry existe (`src/Factory/{ResourceName}Factory.php`)
- Vérifier le framework de test (PHPUnit, Pest)
- Détecter le namespace de tests depuis `composer.json` (autoload-dev)

### 4. Détecter le namespace du projet

- Lire `composer.json` avec Read
- Extraire le namespace depuis `autoload.psr-4`

### 5. Générer les tests

Créer `tests/Api/{ResourceName}Test.php` :

```php
<?php

declare(strict_types=1);

namespace {namespace}\Tests\Api;

use ApiPlatform\Symfony\Bundle\Test\ApiTestCase;
use {namespace}\Entity\{ResourceName};
use Symfony\Component\HttpFoundation\Response;

final class {ResourceName}Test extends ApiTestCase
{
    public function testGetCollection(): void
    {
        $response = static::createClient()->request('GET', '/api/{resource_names}');

        self::assertResponseIsSuccessful();
        self::assertResponseHeaderSame('content-type', 'application/ld+json; charset=utf-8');
        self::assertJsonContains([
            '@context' => '/api/contexts/{ResourceName}',
            '@type' => 'Collection',
        ]);
    }

    public function testGetItem(): void
    {
        // Créer un item de test (adapter selon factory/fixtures)
        $iri = $this->findIriBy({ResourceName}::class, [/* critères */]);

        $response = static::createClient()->request('GET', $iri);

        self::assertResponseIsSuccessful();
        self::assertJsonContains([
            '@type' => '{ResourceName}',
        ]);
    }

    public function testCreateItem(): void
    {
        $response = static::createClient()->request('POST', '/api/{resource_names}', [
            'json' => [
                // Propriétés requises
            ],
            'headers' => [
                'Content-Type' => 'application/ld+json',
            ],
        ]);

        self::assertResponseStatusCodeSame(Response::HTTP_CREATED);
        self::assertJsonContains([
            '@type' => '{ResourceName}',
            // Vérifier les propriétés retournées
        ]);
    }

    public function testCreateItemValidation(): void
    {
        $response = static::createClient()->request('POST', '/api/{resource_names}', [
            'json' => [
                // Données invalides
            ],
            'headers' => [
                'Content-Type' => 'application/ld+json',
            ],
        ]);

        self::assertResponseStatusCodeSame(Response::HTTP_UNPROCESSABLE_ENTITY);
    }

    public function testUpdateItem(): void
    {
        $iri = $this->findIriBy({ResourceName}::class, [/* critères */]);

        $response = static::createClient()->request('PATCH', $iri, [
            'json' => [
                // Propriétés à modifier
            ],
            'headers' => [
                'Content-Type' => 'application/merge-patch+json',
            ],
        ]);

        self::assertResponseIsSuccessful();
        self::assertJsonContains([
            // Vérifier les propriétés mises à jour
        ]);
    }

    public function testDeleteItem(): void
    {
        $iri = $this->findIriBy({ResourceName}::class, [/* critères */]);

        static::createClient()->request('DELETE', $iri);

        self::assertResponseStatusCodeSame(Response::HTTP_NO_CONTENT);
    }

    public function testGetItemNotFound(): void
    {
        static::createClient()->request('GET', '/api/{resource_names}/99999');

        self::assertResponseStatusCodeSame(Response::HTTP_NOT_FOUND);
    }
}
```

### 6. Ajouter les tests de filtres (si configurés)

```php
    public function testFilterByName(): void
    {
        $response = static::createClient()->request('GET', '/api/{resource_names}?name=test');

        self::assertResponseIsSuccessful();
        // Vérifier que les résultats sont filtrés
    }

    public function testOrderBy(): void
    {
        $response = static::createClient()->request('GET', '/api/{resource_names}?order[name]=asc');

        self::assertResponseIsSuccessful();
    }
```

### 7. Ajouter les tests de sécurité (si configurée)

```php
    public function testAccessDeniedWithoutAuth(): void
    {
        static::createClient()->request('POST', '/api/{resource_names}', [
            'json' => [/* données */],
        ]);

        self::assertResponseStatusCodeSame(Response::HTTP_UNAUTHORIZED);
    }

    public function testAccessGrantedWithAuth(): void
    {
        $client = static::createClient();
        // Configurer l'authentification (JWT, session, etc.)

        $client->request('GET', '/api/{resource_names}');

        self::assertResponseIsSuccessful();
    }
```

### 8. Ajouter les tests de pagination

```php
    public function testPagination(): void
    {
        $response = static::createClient()->request('GET', '/api/{resource_names}?page=1');

        self::assertResponseIsSuccessful();
        self::assertJsonContains([
            'totalItems' => self::greaterThanOrEqual(0),
        ]);
    }
```

### 9. Afficher le résumé

```
Tests générés pour {ResourceName}

Fichier créé :
- tests/Api/{ResourceName}Test.php

Tests inclus :
- testGetCollection — Liste des resources
- testGetItem — Récupération d'un item
- testCreateItem — Création
- testCreateItemValidation — Validation des données
- testUpdateItem — Mise à jour (PATCH)
- testDeleteItem — Suppression
- testGetItemNotFound — 404
- testFilterBy... — Tests de filtres (si configurés)
- testAccessDenied... — Tests de sécurité (si configurée)

Exécution :
  php bin/phpunit tests/Api/{ResourceName}Test.php

Prochaines étapes :
- Adapter les données de test (factories, fixtures)
- Compléter les assertions sur les propriétés
- Ajouter les tests de cas limites
```

## Patterns appliqués

### Tests API Platform
- Extension de `ApiTestCase` pour les assertions spécialisées
- Utilisation de `assertJsonContains` pour les assertions partielles
- Content-Type `application/ld+json` pour les requêtes JSON-LD
- Content-Type `application/merge-patch+json` pour PATCH
- `findIriBy()` pour obtenir l'IRI d'un item existant

### Bonnes pratiques
- Un test par opération CRUD
- Tests de validation pour les données invalides
- Tests de sécurité si access control configuré
- Tests de filtres si des filtres sont configurés
- Tests de pagination pour les collections

## Notes
- `ApiTestCase` étend `KernelTestCase` de Symfony
- Utiliser Foundry ou des fixtures pour les données de test
- Les tests sont exécutés dans une transaction rollbackée par défaut
- Pour les tests avec authentification, configurer un token JWT ou une session de test
