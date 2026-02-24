---
title: Démarrage Rapide
---

# Démarrage Rapide

## Prérequis

- [Claude Code](https://claude.ai/code) installé
- Git configuré

## Installation

```bash
# 1. Cloner le marketplace
git clone https://github.com/atournayre/claude-personas.git

# 2. Copier un ou plusieurs personas dans ta configuration Claude Code
cp -r claude-personas/analyst ~/.claude/plugins/analyst
cp -r claude-personas/reviewer ~/.claude/plugins/reviewer
```

## Utilisation

Une fois le persona installé, ses skills sont disponibles via les slash commands :

```
/analyst:discover
/analyst:explore
/reviewer:review
/reviewer:elegant-objects
```

## Choisir ses personas

| Persona | Pour quoi faire |
|---------|----------------|
| **analyst** | Analyser un besoin, explorer un codebase |
| **architect** | Concevoir une architecture, rédiger un ADR |
| **devops** | Gérer branches, commits, PRs |
| **documenter** | Générer et charger de la documentation |
| **implementer** | Écrire du code, corriger des bugs |
| **infra** | Gérer la configuration Claude Code |
| **orchestrator** | Orchestrer un workflow de feature complète |
| **php** | Générer du code PHP/Symfony |
| **researcher** | Rechercher via Gemini/Google |
| **reviewer** | Reviewer du code, vérifier la qualité |
| **tester** | Écrire et exécuter des tests |

## Prochaines étapes

- [Installation détaillée](/guide/installation)
- [Voir tous les personas](/plugins/)
- [Index des commandes](/commands/)
