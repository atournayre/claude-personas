# Symfony UX Twig Component - Référence

## Concept

Un Twig Component = une classe PHP + un template Twig, rendus ensemble comme une unité réutilisable.

## Installation

```bash
composer require symfony/ux-twig-component
```

## Configuration

Fichier `config/packages/twig_component.yaml` :

```yaml
twig_component:
    defaults:
        App\Twig\Components\:
            template_directory: components
```

## Création d'un composant

### Classe PHP

```php
<?php

declare(strict_types=1);

namespace App\Twig\Components;

use Symfony\UX\TwigComponent\Attribute\AsTwigComponent;

#[AsTwigComponent]
final class Alert
{
    public string $type = 'info';
    public string $message;
}
```

### Template Twig

Fichier `templates/components/Alert.html.twig` :

```twig
<div class="alert alert-{{ this.type }}"{{ attributes }}>
    {{ this.message }}
</div>
```

### Utilisation

```twig
{# Syntaxe HTML (recommandée) #}
<twig:Alert type="danger" message="Attention !" />

{# Syntaxe fonction #}
{{ component('Alert', { type: 'danger', message: 'Attention !' }) }}
```

## Props

Les props sont des propriétés publiques de la classe. Elles sont automatiquement assignées par TwigComponent après instanciation.

```php
#[AsTwigComponent]
final class Button
{
    public string $label;
    public string $variant = 'primary';  // Valeur par défaut
    public ?string $icon = null;          // Nullable
    public bool $disabled = false;        // Booléen
}
```

**Règles importantes :**
- Ne pas utiliser `readonly` — TwigComponent assigne les props après le constructeur
- Les props avec valeur par défaut sont optionnelles lors de l'utilisation
- Les props nullable doivent être initialisées à `null`

## mount() — Initialisation

La méthode `mount()` est appelée après l'instanciation pour une initialisation complexe.

```php
#[AsTwigComponent]
final class UserCard
{
    public string $name;
    public string $initials;

    public function mount(string $fullName): void
    {
        $this->name = $fullName;
        $this->initials = implode('', array_map(
            fn(string $part) => mb_strtoupper(mb_substr($part, 0, 1)),
            explode(' ', $fullName)
        ));
    }
}
```

Utilisation : `<twig:UserCard fullName="Jean Dupont" />`

## PreMount — Validation des données

```php
use Symfony\UX\TwigComponent\Attribute\PreMount;
use Symfony\Component\OptionsResolver\OptionsResolver;

#[AsTwigComponent]
final class Alert
{
    public string $type;
    public string $message;

    #[PreMount]
    public function preMount(array $data): array
    {
        $resolver = new OptionsResolver();
        $resolver->setDefaults(['type' => 'info']);
        $resolver->setRequired('message');
        $resolver->setAllowedValues('type', ['info', 'warning', 'danger', 'success']);

        return $resolver->resolve($data);
    }
}
```

Plusieurs `#[PreMount]` avec priorité : `#[PreMount(priority: 10)]` (plus élevé = appelé en premier).

## PostMount — Post-traitement

```php
use Symfony\UX\TwigComponent\Attribute\PostMount;

#[AsTwigComponent]
final class Alert
{
    public string $type = 'info';
    public string $message;

    #[PostMount]
    public function postMount(array $data): array
    {
        if (str_contains($this->message, 'erreur')) {
            $this->type = 'danger';
        }

        return $data; // Retourner les props non traitées
    }
}
```

## Computed Properties

Les propriétés calculées sont mises en cache pour la durée du rendu.

```php
#[AsTwigComponent]
final class ProductList
{
    public string $category;

    public function __construct(
        private ProductRepository $productRepository,
    ) {}

    public function getProducts(): array
    {
        return $this->productRepository->findByCategory($this->category);
    }

    public function getTotal(): int
    {
        return count($this->getProducts());
    }
}
```

**Dans le template :**

```twig
{# computed.xxx — appel unique, résultat mis en cache #}
{% for product in computed.products %}
    <li>{{ product.name }}</li>
{% endfor %}
<p>Total : {{ computed.total }}</p>
```

**Attention :** Ne pas utiliser `#[ExposeInTemplate]` sur une computed method, sinon elle sera appelée deux fois.

## ExposeInTemplate — Exposer des propriétés privées

```php
use Symfony\UX\TwigComponent\Attribute\ExposeInTemplate;

#[AsTwigComponent]
final class Badge
{
    #[ExposeInTemplate]
    private string $color = 'blue';

    #[ExposeInTemplate('badge_label')]
    private string $label;

    #[ExposeInTemplate(name: 'ico', getter: 'fetchIcon')]
    private string $icon;

    public function fetchIcon(): string
    {
        return 'icon-' . $this->icon;
    }
}
```

Accès dans le template : `{{ color }}`, `{{ badge_label }}`, `{{ ico }}`

## Slots / Blocks

Les composants supportent la composition de contenu via les blocks Twig.

**Template du composant (`Card.html.twig`) :**

```twig
<div class="card"{{ attributes }}>
    <div class="card-header">
        {% block header %}
            <h3>{{ this.title }}</h3>
        {% endblock %}
    </div>
    <div class="card-body">
        {% block content %}{% endblock %}
    </div>
    <div class="card-footer">
        {% block footer %}{% endblock %}
    </div>
</div>
```

**Utilisation :**

```twig
<twig:Card title="Mon titre">
    {% block header %}
        <h2 class="custom">Titre personnalisé</h2>
    {% endblock %}

    {% block content %}
        <p>Contenu principal</p>
    {% endblock %}

    {% block footer %}
        <button>Valider</button>
    {% endblock %}
</twig:Card>
```

## Attributs HTML (ComponentAttributes)

Les attributs non reconnus comme props sont passés comme attributs HTML.

```twig
{# Utilisation #}
<twig:Alert type="info" message="Hello" class="my-alert" id="alert-1" />

{# Template du composant #}
<div{{ attributes }}>
    {{ this.message }}
</div>

{# Rendu HTML final #}
<div class="my-alert" id="alert-1">
    Hello
</div>
```

**Manipulation des attributs dans le template :**

```twig
{# Valeurs par défaut #}
<div{{ attributes.defaults({ class: 'alert', role: 'alert' }) }}>

{# Extraire un attribut #}
{% set icon = attributes.render('icon') %}

{# Sans un attribut spécifique #}
<div{{ attributes.without('class') }}>
```

## Composants Anonymous

Composants sans classe PHP — template uniquement.

**Fichier `templates/components/Badge.html.twig` :**

```twig
{% props label, variant = 'default', size = 'md' %}

<span class="badge badge-{{ variant }} badge-{{ size }}"{{ attributes }}>
    {{ label }}
</span>
```

**Utilisation :**

```twig
<twig:Badge label="Nouveau" variant="success" />
```

## Sous-composants (Namespacing)

Organiser les composants en sous-répertoires :

```
src/Twig/Components/
  Form/
    Input.php
    Select.php
    Textarea.php
templates/components/
  Form/
    Input.html.twig
    Select.html.twig
    Textarea.html.twig
```

**Utilisation avec `:` :**

```twig
<twig:Form:Input name="email" type="email" />
<twig:Form:Select name="country" :options="countries" />
```

## CVA (Class Variant Authority)

Gestion des variantes CSS avec `html_cva()` (package `twig/html-extra:^3.12`).

```twig
{% set button = html_cva(
    'btn font-semibold',
    {
        variants: {
            color: {
                primary: 'bg-blue-500 text-white',
                danger: 'bg-red-500 text-white',
                success: 'bg-green-500 text-white',
            },
            size: {
                sm: 'text-sm px-2 py-1',
                md: 'text-base px-4 py-2',
                lg: 'text-lg px-6 py-3',
            },
        },
        defaultVariants: {
            color: 'primary',
            size: 'md',
        },
    }
) %}

<button class="{{ button.apply({ color: this.color, size: this.size }) }}"{{ attributes }}>
    {{ this.label }}
</button>
```

## Injection de dépendances

Les composants sont des services Symfony — l'injection via constructeur fonctionne.

```php
#[AsTwigComponent]
final class LatestArticles
{
    public int $limit = 5;

    public function __construct(
        private ArticleRepository $articleRepository,
    ) {}

    public function getArticles(): array
    {
        return $this->articleRepository->findLatest($this->limit);
    }
}
```

**Important :** Le constructeur est réservé à l'injection de dépendances. Les props sont assignées APRÈS le constructeur. Utiliser `mount()` pour l'initialisation basée sur les props.

## Bonnes pratiques

1. **Isolation** — Un composant ne doit pas connaître le contexte de la page
2. **Props unidirectionnelles** — Les props vont du parent vers l'enfant uniquement
3. **Pas de `readonly`** — TwigComponent doit pouvoir assigner les props après instanciation
4. **`computed.xxx`** — Toujours utiliser `computed.` pour les méthodes appelées plusieurs fois
5. **`{{ attributes }}`** — Toujours inclure sur l'élément racine
6. **`final`** — Toujours déclarer la classe comme `final`
7. **YAGNI** — Ne pas anticiper les besoins, ajouter uniquement ce qui est demandé
8. **Composition** — Préférer la composition (slots/blocks) à l'héritage
