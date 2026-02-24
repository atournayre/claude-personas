---
name: symfony:form
description: Genere un FormType Symfony avec contraintes de validation et options
model: sonnet
allowed-tools: [AskUserQuestion, Bash, Read, Write, Edit, Grep, Glob]
version: 1.0.0
license: MIT
---

# Symfony Form Skill

Genere un FormType Symfony complet avec champs types, contraintes de validation, options et bonnes pratiques.

## Variables
- **{FormName}** - Nom du formulaire en PascalCase (ex: ProductType)
- **{namespace}** - Namespace du projet (defaut: App)
- **{fields}** - Liste des champs avec types et contraintes

## Outputs
- `src/Form/{FormName}.php`

## Instructions a Executer

**IMPORTANT : Execute ce workflow etape par etape :**

### 1. Demander le nom du formulaire

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quel est le nom du formulaire ? (ex: Product, UserRegistration)"
  Header: "Formulaire"
  ```
- Ajoute le suffixe `Type` si absent
- Stocke dans FormName

### 2. Demander les champs

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quels champs ? Format: name:TextType,email:EmailType,price:MoneyType,category:EntityType:Category,description:TextareaType:nullable"
  Header: "Champs"
  ```
- Parse la liste des champs :
  - `name:FieldType` — champ simple
  - `name:EntityType:TargetEntity` — champ relation Doctrine
  - `name:Type:nullable` — champ nullable

### 3. Demander les options avancees

- Utilise AskUserQuestion (multiSelect: true) pour demander :
  ```
  Question: "Quelles options activer ?"
  Header: "Options"
  Options:
    - "Data class binding" : "Lier le formulaire a une classe PHP (entite/DTO)"
    - "CSRF protection" : "Protection CSRF explicite (active par defaut dans Symfony)"
    - "Validation groups" : "Groupes de validation pour valider conditionnellement"
  ```

### 4. Si Data class : demander la classe

- Utilise AskUserQuestion pour demander :
  ```
  Question: "Quelle est la classe de donnees liee ? (ex: App\Entity\Product, App\Dto\ProductInput)"
  Header: "Data class"
  ```

### 5. Detecter le namespace du projet

- Lis `composer.json` avec Read
- Extrais le namespace depuis `autoload.psr-4`
- Si non trouve, utilise `App` par defaut

### 6. Generer le FormType

- Cree le fichier `src/Form/{FormName}.php` avec Write
- Structure de classe :

```php
<?php

declare(strict_types=1);

namespace {namespace}\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Validator\Constraints as Assert;

final class {FormName} extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('name', TextType::class, [
                'label' => 'Nom',
                'constraints' => [
                    new Assert\NotBlank(),
                    new Assert\Length(max: 255),
                ],
            ])
        ;
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'data_class' => EntityClass::class,
        ]);
    }
}
```

**Regles de generation :**
- Classe `final` etendant `AbstractType`
- Chaque champ a un type explicite (pas de devinette)
- Contraintes de validation inline via `constraints` (pas d'annotations sur l'entite)
- Types de champs Symfony utilises :
  - `TextType`, `EmailType`, `PasswordType`, `TextareaType`
  - `IntegerType`, `MoneyType`, `NumberType`, `PercentType`
  - `ChoiceType`, `EntityType`, `EnumType`
  - `DateType`, `DateTimeType`, `TimeType`
  - `CheckboxType`, `FileType`, `HiddenType`
  - `CollectionType`, `RepeatedType`
- Pour `EntityType` : ajouter `class`, `choice_label`, `query_builder` si necessaire
- Pour `ChoiceType` : ajouter `choices` avec les valeurs
- Si validation groups : ajouter `'validation_groups'` dans `configureOptions`
- Labels explicites pour chaque champ

### 7. Afficher le resume

Affiche :
```
FormType {FormName} genere avec succes

Fichiers crees :
- src/Form/{FormName}.php

Champs :
{liste des champs avec types}

Utilisation dans un controleur :
  $form = $this->createForm({FormName}::class, $entity);
  $form->handleRequest($request);
  if ($form->isSubmitted() && $form->isValid()) {
      // Traitement
  }

Prochaines etapes :
- Ajuster les contraintes de validation
- Personnaliser les labels et placeholders
- Ajouter un template Twig si necessaire
```

## Patterns appliques

### FormType
- Classe `final`, extends `AbstractType`
- Types de champs explicites
- Contraintes de validation inline (`constraints` option)
- `configureOptions()` pour data_class et defaults
- Labels explicites

## Notes
- Preferer les contraintes inline (`constraints` dans les options du champ) aux annotations sur l'entite
- Toujours specifier le type de champ explicitement (pas de type-guessing)
- Utiliser `Assert\` alias pour les contraintes
- Pour les relations Doctrine, utiliser `EntityType` avec `query_builder` pour filtrer
- `CollectionType` pour les relations one-to-many editables
