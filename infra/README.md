# infra

Infrastructure Claude Code : gestion mémoire (CLAUDE.md/.claude/rules), création de skills et agents, alias, versioning des plugins, initialisation marketplace, correction grammaticale.

## Skills

| Commande | Description |
|----------|-------------|
| `/infra:alias-add` | Créer un alias de commande |
| `/infra:bump` | Mettre à jour la version d'un plugin |
| `/infra:fix-grammar` | Corriger la grammaire et l'orthographe |
| `/infra:init` | Initialiser un nouveau marketplace |
| `/infra:make-subagent` | Créer un subagent Claude Code |
| `/infra:memory` | Créer et optimiser les fichiers CLAUDE.md |
| `/infra:skill-creator` | Créer une nouvelle skill |

## Agents

| Agent | Rôle |
|-------|------|
| `action` | Exécuteur d'actions conditionnelles |
| `meta-agent` | Génère un fichier de configuration d'agent |

## Installation

```bash
cp -r infra ~/.claude/plugins/infra
```
