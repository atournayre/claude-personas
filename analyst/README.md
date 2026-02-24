# analyst

Analyse de besoin, exploration de codebase et clarification avant développement.

## Skills

| Commande | Description |
|----------|-------------|
| `/analyst:clarify` | Lever les ambiguïtés avant de coder |
| `/analyst:discover` | Comprendre le besoin avant développement |
| `/analyst:explore` | Explorer le codebase avec agents parallèles |
| `/analyst:impact` | Analyser l'impact d'une modification |

## Agents

| Agent | Rôle |
|-------|------|
| `analyst` | Analyse architecture + design DDD |
| `designer` | Conçoit le design DDD, contrats et interfaces |
| `explore-codebase` | Exploration rapide du codebase |
| `gemini-analyzer` | Délègue l'analyse de contextes ultra-longs à Gemini |

## Installation

```bash
cp -r analyst ~/.claude/plugins/analyst
```

## Dépendances optionnelles

- `gemini` — requis pour l'agent `gemini-analyzer`
