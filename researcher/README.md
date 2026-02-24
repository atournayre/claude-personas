# researcher

Recherche et analyse via Gemini (Google Search) et agents web spécialisés.

## Skills

| Commande | Description |
|----------|-------------|
| `/researcher:analyze` | Analyser une codebase ou documentation avec Gemini |
| `/researcher:search` | Recherche temps réel via Google Search (Gemini) |

## Agents

| Agent | Rôle |
|-------|------|
| `explore-docs` | Exploration de documentation |
| `gemini-researcher` | Recherche via Google Search intégré à Gemini |
| `websearch` | Recherche web générale |

## Installation

```bash
cp -r researcher ~/.claude/plugins/researcher
```

## Dépendances optionnelles

- `gemini` — requis pour les skills `analyze` et `search`
