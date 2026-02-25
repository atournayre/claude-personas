# Claude Personas

Marketplace de **personas** (rôles spécialisés) pour [Claude Code](https://claude.ai/code).


## Personas disponibles

| Persona | Rôle | Skills | Agents |
|---------|------|--------|--------|
| **analyst** | Analyse, exploration, découverte | clarify, discover, explore, impact | analyst, designer, explore-codebase, gemini-analyzer |
| **api-platform** | API REST/GraphQL, State Providers/Processors | make-resource, make-filter, make-provider, make-processor, make-dto, make-test, audit | api-expert, reviewer |
| **architect** | Architecture, design, ADR | adr, design, plan, start | architect, challenger, deep-think |
| **devops** | Git workflow, CI/CD | branch, cd-pr, commit, conflict, pr, release-notes… | - |
| **documenter** | Documentation technique | claude-load, load, rtfm, summary, update… | 5 scrapers |
| **implementer** | Implémentation & debug | code, debug, fix-issue, fix-pr-comments, refactor… | developer, implementer |
| **infra** | Infrastructure Claude Code | alias-add, bump, init, memory, skill-creator… | action, meta-agent |
| **orchestrator** | Orchestration de features | feature, team, parallel, ralph, validate… | - |
| **php** | Développement PHP/Symfony | make-entity, make-collection, make-contracts… | - |
| **symfony** | Expert Symfony / écosystème officiel | console, controller, form, event, message, voter, mailer, config, diagnose | symfony-expert, security-auditor |
| **researcher** | Recherche & analyse | analyze, search | explore-docs, gemini-researcher, websearch |
| **reviewer** | Revue de code & qualité | challenge, elegant-objects, phpstan, review | 6 agents |
| **tester** | Tests & TDD | ui-test | test-analyzer, tester |
| **twig** | Twig/Symfony UX | make-component | - |

## Installation

```bash
# Cloner les personas
git clone https://github.com/atournayre/claude-personas.git ~/.claude/personas

# Copier un persona dans ton projet
cp -r ~/.claude/personas/analyst ~/.claude/plugins/analyst
```

## Structure

```
persona-name/
  .claude-plugin/
    plugin.json        # Metadata semver, auteur, description, category
  DEPENDENCIES.json    # Dépendances inter-personas (optionnel)
  skills/              # Skills invocables via /persona:skill
    skill-name/
      SKILL.md
  agents/              # Agents spécialisés
    agent-name.md
```

## Dépendances optionnelles

Certains personas utilisent optionnellement des plugins du marketplace :
- `analyst` → `gemini` (pour gemini-analyzer)
- `architect` → `gemini` (pour deep-think)
- `php` → `symfony` (pour les makers)

## Licence

MIT — [Aurélien Tournayre](https://github.com/atournayre)
