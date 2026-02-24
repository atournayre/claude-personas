# architect

Design architectural, planification d'implémentation et documentation des décisions techniques.

## Skills

| Commande | Description |
|----------|-------------|
| `/architect:adr` | Générer un Architecture Decision Record |
| `/architect:design` | Designer 2-3 approches architecturales |
| `/architect:plan` | Générer un plan d'implémentation |
| `/architect:start` | Démarrer un développement avec mode plan |

## Agents

| Agent | Rôle |
|-------|------|
| `architect` | Analyse l'architecture et propose une conception technique |
| `challenger` | Avocat du diable : challenge les propositions et identifie les failles |
| `deep-think` | Délègue les problèmes complexes à Gemini Deep Think |

## Installation

```bash
cp -r architect ~/.claude/plugins/architect
```

## Dépendances optionnelles

- `gemini` — requis pour l'agent `deep-think`
