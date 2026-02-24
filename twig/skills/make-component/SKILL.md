---
name: twig:make-component
description: Génère un Twig Component Symfony UX (classe PHP + template Twig)
model: sonnet
allowed-tools: [AskUserQuestion, Bash, Read, Write, Edit, Grep, Glob]
version: 1.0.0
license: MIT
---

# Twig Make Component Skill

Génère un Twig Component Symfony UX complet : classe PHP avec attribut `#[AsTwigComponent]` et template Twig associé.

## Variables
- **{ComponentName}** - Nom du composant en PascalCase (ex: AlertMessage)
- **{componentName}** - Nom du composant en snake_case pour le template (ex: alert_message)
- **{namespace}** - Namespace du projet (défaut: App)
- **{props}** - Liste des propriétés/props (name:type,...)
- **{type}** - Type de composant : standard ou anonymous

## Outputs (composant standard)
- `src/Twig/Components/{ComponentName}.php`
- `templates/components/{ComponentName}.html.twig`

## Outputs (composant anonymous)
- `templates/components/{ComponentName}.html.twig`

## Instructions à Exécuter

**IMPORTANT : Exécute ce workflow étape par étape :**

### 1. Demander le nom du composant

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quel est le nom du composant Twig à créer ?"
  Header: "Composant"
  ```
- Valide que le nom est en PascalCase (première lettre majuscule)
- Stocke dans ComponentName
- Génère componentName = ComponentName converti en snake_case (ex: AlertMessage → alert_message)
- Si le nom contient `:` (ex: `Form:Input`), il représente un sous-répertoire :
  - Classe PHP : `src/Twig/Components/Form/Input.php`
  - Template : `templates/components/Form/Input.html.twig`

### 2. Demander le type de composant

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quel type de composant voulez-vous créer ?"
  Header: "Type"
  Options:
    - "Standard (Recommandé)" : "Classe PHP + template Twig — composant complet avec logique métier"
    - "Anonymous" : "Template Twig seul — composant purement visuel sans logique PHP"
  ```
- Si anonymous : passer directement à l'étape 5 (template uniquement)

### 3. Demander les props du composant

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quelles sont les props du composant ? Format: label:string,type:string,icon:?string (préfixer par ? pour nullable). Laisser vide si aucune."
  Header: "Props"
  ```
- Parse la liste des propriétés
- Pour chaque propriété, extrais :
  - Le nom (camelCase)
  - Le type PHP (string, int, bool, float, array, ?string pour nullable)
  - Si nullable (préfixé par ?)

### 4. Demander les options avancées

- Utilise AskUserQuestion (multiSelect: true) pour demander :
  ```
  Question: "Quelles options activer pour ce composant ?"
  Header: "Options"
  Options:
    - "mount()" : "Méthode d'initialisation appelée à la création du composant"
    - "Computed properties" : "Propriétés calculées accessibles via computed.xxx dans le template"
    - "Slots (blocks)" : "Blocs enfants pour la composition de contenu"
  ```

### 5. Détecter le namespace du projet

- Lis `composer.json` avec Read
- Extrais le namespace depuis `autoload.psr-4`
- Si non trouvé, utilise `App` par défaut

### 6. Vérifier que le bundle est installé

- Exécute `grep -q "ux-twig-component" composer.json` avec Bash
- Si non trouvé :
  - Affiche : `⚠️  Le package symfony/ux-twig-component ne semble pas installé.`
  - Affiche : `➡️  Installation recommandée : composer require symfony/ux-twig-component`
  - Continue la génération malgré tout

### 7. Générer la classe PHP (composant standard uniquement)

- Créé le fichier `src/Twig/Components/{ComponentName}.php` avec Write
- Structure de classe :

```php
<?php

declare(strict_types=1);

namespace {namespace}\Twig\Components;

use Symfony\UX\TwigComponent\Attribute\AsTwigComponent;

#[AsTwigComponent]
final class {ComponentName}
{
    // Props publiques (données passées au composant)
    public string $label;
    public string $type = 'default';

    // Si mount() demandé :
    public function mount(/* params */): void
    {
        // Initialisation
    }

    // Si computed properties demandées :
    public function getFormattedLabel(): string
    {
        return strtoupper($this->label);
    }
}
```

**Règles de génération de la classe :**
- Classe `final` (pas de `readonly` — incompatible avec TwigComponent)
- Attribut `#[AsTwigComponent]` sans argument si le nom du composant correspond au nom de la classe
- Props déclarées comme propriétés `public`
- Les props avec valeur par défaut doivent avoir une valeur d'initialisation
- Les props nullable doivent être typées `?type` et initialisées à `null`
- Ne PAS utiliser de constructeur pour les props — TwigComponent les assigne après instanciation
- Si `mount()` est demandé : ajouter la méthode avec les paramètres qui ne correspondent pas directement à des propriétés
- Si computed properties : ajouter des méthodes `get{PropertyName}()` avec le type de retour approprié
- Pas de `readonly` sur les propriétés — TwigComponent doit pouvoir les modifier après instanciation

### 8. Générer le template Twig

- Créé le fichier `templates/components/{ComponentName}.html.twig` avec Write

**Template pour composant standard :**
```twig
<div{{ attributes }}>
    {# Props disponibles via this.propName #}
    {# Computed via computed.methodName #}

    {% if slots demandés %}
    {% block content %}{% endblock %}
    {% endif %}
</div>
```

**Template pour composant anonymous :**
```twig
{% props label, type = 'default' %}

<div{{ attributes }}>
    {{ label }}
</div>
```

**Règles de génération du template :**
- Toujours inclure `{{ attributes }}` sur l'élément racine pour supporter les attributs HTML passés au composant
- Les props du composant standard sont accessibles via `{{ this.propName }}`
- Les computed properties sont accessibles via `{{ computed.methodName }}`
- Pour les composants anonymous : utiliser `{% props %}` pour déclarer les props avec valeurs par défaut
- Si slots/blocks demandés : ajouter `{% block content %}{% endblock %}` pour le contenu enfant
- Si le composant a des props nullable : utiliser `{% if this.propName %}` pour les affichages conditionnels

### 9. Afficher le résumé

Affiche :
```
✅ Composant {ComponentName} généré avec succès

Fichiers créés :
- src/Twig/Components/{ComponentName}.php  (si standard)
- templates/components/{ComponentName}.html.twig

Props :
{liste des propriétés avec types}

Utilisation dans un template Twig :
  <twig:{ComponentName} label="Mon texte" type="primary" />

  Avec contenu (si slots) :
  <twig:{ComponentName} label="Mon texte">
      <p>Contenu enfant</p>
  </twig:{ComponentName}>

Prochaines étapes :
- Ajouter la logique métier dans la classe PHP
- Personnaliser le template Twig
- Utiliser computed.xxx pour les propriétés calculées
```

## Patterns appliqués

### Classe PHP
- Classe `final` (jamais `readonly`)
- Attribut `#[AsTwigComponent]`
- Props publiques (pas de getters/setters pour les props)
- Pas de constructeur pour l'injection de props
- `mount()` pour l'initialisation complexe
- Méthodes `get*()` pour les computed properties

### Template Twig
- `{{ attributes }}` sur l'élément racine
- Syntaxe HTML `<twig:ComponentName>` pour l'utilisation
- `{% block content %}{% endblock %}` pour les slots
- `{{ computed.xxx }}` pour les propriétés calculées (appel unique, mis en cache)

### Composant anonymous
- Template seul, sans classe PHP
- `{% props %}` pour déclarer les props
- Idéal pour les composants purement visuels

## References

- [Twig Component](references/twig-component.md) - Documentation détaillée Symfony UX Twig Component

## Notes
- Ne JAMAIS utiliser `readonly` sur la classe ou les propriétés du composant
- Les props sont assignées après instanciation par TwigComponent
- Préférer les computed properties (`computed.xxx`) aux appels multiples de méthodes dans le template
- Un composant doit être isolé : il ne doit pas dépendre du contexte de la page
- Les props circulent dans un seul sens : parent → enfant
