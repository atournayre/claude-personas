# documenter

Documentation : RTFM, génération docs, chargement frameworks, scraping agents.

## Skills

| Commande | Description |
|----------|-------------|
| `/documenter:claude-load` | Charger la documentation Claude Code |
| `/documenter:claude-question` | Interroger la documentation Claude Code locale |
| `/documenter:load` | Charger la documentation d'un framework |
| `/documenter:rtfm` | Lire la documentation technique |
| `/documenter:summary` | Résumer ce qui a été construit |
| `/documenter:update` | Créer/mettre à jour la documentation du projet |

## Agents

| Agent | Rôle |
|-------|------|
| `api-platform-docs-scraper` | Extrait la documentation API Platform |
| `atournayre-framework-docs-scraper` | Extrait la documentation atournayre-framework |
| `claude-docs-scraper` | Extrait la documentation Claude Code |
| `meilisearch-docs-scraper` | Extrait la documentation Meilisearch |
| `symfony-docs-scraper` | Extrait la documentation Symfony |

## Installation

```bash
cp -r documenter ~/.claude/plugins/documenter
```
