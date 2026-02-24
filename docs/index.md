---
layout: home

hero:
  name: Claude Personas
  text: Rôles spécialisés pour Claude Code
  tagline: Des personas qui adoptent un rôle précis dans ton workflow de développement
  image:
    src: /og-image.png
    alt: Claude Personas illustration
  actions:
    - theme: brand
      text: Démarrer
      link: /guide/getting-started
    - theme: alt
      text: Voir les personas
      link: /plugins/

features:
  - icon: 🔍
    title: Analyst
    details: Analyse, exploration, découverte du besoin, clarification
    link: /plugins/analyst

  - icon: 🏗️
    title: Architect
    details: Architecture, design, ADR, planning
    link: /plugins/architect

  - icon: 💻
    title: Implementer
    details: Implémentation, debug, fix, refactoring
    link: /plugins/implementer

  - icon: 🔎
    title: Reviewer
    details: Revue de code, qualité, PHPStan, Elegant Objects
    link: /plugins/reviewer

  - icon: 🧪
    title: Tester
    details: Tests unitaires, UI, TDD
    link: /plugins/tester

  - icon: 🎯
    title: Orchestrator
    details: Coordination de l'équipe de personas sur une feature complète
    link: /plugins/orchestrator
---

<script setup>
import { data as plugins } from './.vitepress/data/plugins.data'
import { computed } from 'vue'

const totalSkills = computed(() =>
  plugins.reduce((sum, p) => sum + p.skillCount, 0)
)

const totalAgents = computed(() =>
  plugins.reduce((sum, p) => sum + p.agentCount, 0)
)
</script>

## Installation rapide

```bash
# Ajouter les personas
/plugin marketplace add atournayre/claude-personas

# Installer un persona
/plugin install analyst@atournayre
```

## Statistiques

- **{{ plugins.length }} personas** disponibles
- **{{ totalSkills }} skills** pour automatiser ton workflow
- **{{ totalAgents }} agents** spécialisés
- **Open Source** (MIT)

## Qu'est-ce qu'un persona ?

Un **persona** est différent d'un outil. Là où un outil (`/git:commit`, `/gemini:analyze`) exécute une tâche spécifique, un persona **adopte un rôle complet** dans le processus de développement.

| Outil | Persona |
|-------|---------|
| Fait une chose précise | Adopte un point de vue complet |
| Invoqué ponctuellement | Peut être utilisé sur toute une phase |
| Ex : `/git:commit` | Ex : `reviewer` qui analyse tout le code |

## Personas disponibles

| Persona | Rôle | Skills |
|---------|------|--------|
| [analyst](/plugins/analyst) | Analyse & découverte du besoin | clarify, discover, explore, impact |
| [architect](/plugins/architect) | Architecture & design | adr, design, plan, start |
| [devops](/plugins/devops) | Git workflow & CI/CD | branch, commit, pr, release-notes… |
| [documenter](/plugins/documenter) | Documentation technique | load, rtfm, summary, update… |
| [implementer](/plugins/implementer) | Implémentation & debug | code, debug, fix-issue, refactor… |
| [infra](/plugins/infra) | Infrastructure Claude Code | bump, init, memory, skill-creator… |
| [orchestrator](/plugins/orchestrator) | Orchestration de features | feature, team, parallel, validate… |
| [php](/plugins/php) | Développement PHP/Symfony | make-entity, make-collection… |
| [researcher](/plugins/researcher) | Recherche & analyse | analyze, search |
| [reviewer](/plugins/reviewer) | Revue de code & qualité | challenge, elegant-objects, phpstan, review |
| [tester](/plugins/tester) | Tests & TDD | ui-test |

## Contribuer

- **Repository GitHub** : [atournayre/claude-personas](https://github.com/atournayre/claude-personas)
- **Issues** : Signaler un bug ou proposer un nouveau persona
- **Pull Requests** : Contribuer du code ou de la documentation

### Développement local

```bash
git clone https://github.com/atournayre/claude-personas.git
cd claude-personas/docs
npm install
npm run dev
```
