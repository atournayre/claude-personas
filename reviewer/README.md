# reviewer

Skills de review de code : qualité, PHPStan, Elegant Objects, challenge adversarial.

## Skills

| Commande | Description |
|----------|-------------|
| `/reviewer:challenge` | Évaluer et challenger la dernière réponse |
| `/reviewer:elegant-objects` | Vérifier la conformité aux principes Elegant Objects |
| `/reviewer:phpstan` | Résoudre automatiquement les erreurs PHPStan |
| `/reviewer:review` | Review qualité complète du code |

## Agents

| Agent | Rôle |
|-------|------|
| `code-reviewer` | Revue de code Pull Request |
| `elegant-objects-reviewer` | Vérifie la conformité aux principes Elegant Objects |
| `git-history-reviewer` | Analyse l'historique Git |
| `phpstan-error-resolver` | Résout les erreurs PHPStan niveau 9 |
| `qa` | Découverte et exécution des outils QA du projet |
| `silent-failure-hunter` | Détecte les échecs silencieux dans le code |

## Installation

```bash
cp -r reviewer ~/.claude/plugins/reviewer
```
