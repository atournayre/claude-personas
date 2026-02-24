---
title: Index des Agents
---

# Index des Agents

27 agents disponibles dans le marketplace.

**Note** : Les agents sont des sous-agents spécialisés qui peuvent être invoqués via le Task tool. ⚠️ = plugin déprécié.

| Agent | Plugin | Description | Outils |
|-------|--------|-------------|--------|
| `analyst/analyst` | [analyst](/plugins/analyst) | Analyse architecture + design DDD : explore le codebase, propose l'architecture technique et conçoit le modèle de domaine. À utiliser dans le cadre d'une équipe d'agents pour la phase d'analyse. | Read, Grep, Glob, Bash |
| `analyst/designer` | [analyst](/plugins/analyst) | Conçoit le design DDD, les contrats, interfaces et flux de données. À utiliser dans le cadre d'une équipe d'agents pour la phase d'analyse. | Read, Grep, Glob, Bash |
| `analyst/explore-codebase` | [analyst](/plugins/analyst) | Exploration spécialisée du codebase pour identifier les patterns et fichiers pertinents à une feature | Read, Grep, Glob |
| `analyst/gemini-analyzer` | [analyst](/plugins/analyst) | Délègue l'analyse de contextes ultra-longs (codebases, docs) à Gemini Pro (1M tokens). À utiliser quand le contexte dépasse les capacités de Claude ou pour analyser une codebase entière. | Bash, Read, Glob, Grep |
| `architect/architect` | [architect](/plugins/architect) | Analyse l'architecture, les patterns et la structure du codebase pour proposer une conception technique solide. À utiliser dans le cadre d'une équipe d'agents pour la phase d'analyse. | Read, Grep, Glob, Bash |
| `architect/challenger` | [architect](/plugins/architect) | Avocat du diable : challenge les propositions, identifie les edge cases, failles de sécurité et alternatives. À utiliser dans le cadre d'une équipe d'agents pour la phase de challenge. | Read, Grep, Glob, Bash |
| `architect/deep-think` | [architect](/plugins/architect) | Délègue les problèmes complexes (math, logique, architecture) à Gemini Deep Think. À utiliser pour réflexion approfondie nécessitant exploration multi-hypothèses. | Bash |
| `documenter/api-platform-docs-scraper` | [documenter](/plugins/documenter) | À utiliser de manière proactive pour extraire et sauvegarder spécifiquement la documentation API Platform dans docs/api-platform/. Spécialisé pour créer des fichiers individuels par URL sans écrasement. | WebFetch, Read, Write, MultiEdit, Grep, Glob |
| `documenter/atournayre-framework-docs-scraper` | [documenter](/plugins/documenter) | A utiliser de manière proactive pour extraire et sauvegarder la documentation d'atournayre-framework depuis readthedocs.io | WebFetch, Write, Read, Glob |
| `documenter/claude-docs-scraper` | [documenter](/plugins/documenter) | À utiliser de manière proactive pour extraire et sauvegarder spécifiquement la documentation Claude Code dans docs/claude/. Spécialisé pour créer des fichiers individuels par URL sans écrasement. | WebFetch, Read, Write, MultiEdit, Grep, Glob |
| `documenter/meilisearch-docs-scraper` | [documenter](/plugins/documenter) | À utiliser de manière proactive pour extraire et sauvegarder spécifiquement la documentation Meilisearch dans docs/meilisearch/. Spécialisé pour créer des fichiers individuels par URL sans écrasement. | WebFetch, Read, Write, MultiEdit, Grep, Glob |
| `documenter/symfony-docs-scraper` | [documenter](/plugins/documenter) | À utiliser de manière proactive pour extraire et sauvegarder spécifiquement la documentation Symfony dans docs/symfony/. Spécialisé pour créer des fichiers individuels par URL sans écrasement. | WebFetch, Read, Write, MultiEdit, Grep, Glob |
| `implementer/developer` | [implementer](/plugins/implementer) | Implémente le code de production selon le plan validé. Accès écriture aux fichiers. À utiliser dans le cadre d'une équipe d'agents pour la phase d'implémentation. | Read, Write, Edit, Grep, Glob, Bash |
| `implementer/implementer` | [implementer](/plugins/implementer) | Implémente le code ET écrit les tests selon le plan validé. Accès écriture complet. À utiliser dans le cadre d'une équipe d'agents pour la phase d'implémentation. | Read, Write, Edit, Grep, Glob, Bash |
| `infra/action` | [infra](/plugins/infra) | Exécuteur conditionnel d'actions — vérifie indépendamment chaque item avant d'agir (exports/types, fichiers, dépendances). Traite jusqu'à 5 tâches en batch. À utiliser pour supprimer des éléments inutilisés ou exécuter des actions conditionnelles. | Read, Grep, Glob, Bash |
| `infra/meta-agent` | [infra](/plugins/infra) | Génère un nouveau fichier de configuration d'agent Claude Code complet à partir de la description d'un utilisateur. À utiliser proactivement quand l'utilisateur demande de créer un nouveau sous-agent. | Write, Read, Glob, Grep, Bash |
| `researcher/explore-docs` | [researcher](/plugins/researcher) | Use this agent to research library documentation and gather implementation context using Context7 MCP | N/A |
| `researcher/gemini-researcher` | [researcher](/plugins/researcher) | Recherche infos fraîches via Google Search intégré à Gemini. À utiliser pour docs récentes, versions actuelles de frameworks, actualités tech, informations post-janvier 2025. | Bash |
| `researcher/websearch` | [researcher](/plugins/researcher) | Use this agent when you need to make a quick web search. | WebSearch, WebFetch |
| `reviewer/code-reviewer` | [reviewer](/plugins/reviewer) | Review de code complète pour conformité CLAUDE.md, détection de bugs et qualité. Scoring 0-100 avec seuil 80. | Read, Grep, Glob, Bash |
| `reviewer/elegant-objects-reviewer` | [reviewer](/plugins/reviewer) | Spécialiste pour examiner le code PHP et vérifier la conformité aux principes Elegant Objects de Yegor Bugayenko. | Read, Grep, Glob, Bash |
| `reviewer/git-history-reviewer` | [reviewer](/plugins/reviewer) | Analyse le contexte historique git (blame, PRs précédentes, commentaires) pour détecter des problèmes potentiels dans les changements actuels. | Bash, Read, Grep |
| `reviewer/phpstan-error-resolver` | [reviewer](/plugins/reviewer) | Analyse et corrige systématiquement les erreurs PHPStan niveau 9 dans les projets PHP/Symfony. Spécialiste pour résoudre les problèmes de types stricts, annotations generics, array shapes et collections Doctrine. | Read, Edit, Grep, Glob, Bash |
| `reviewer/qa` | [reviewer](/plugins/reviewer) | QA : découverte dynamique et exécution de tous les outils QA du projet. À utiliser dans le cadre d'une équipe d'agents pour la phase de validation finale. | Read, Grep, Glob, Bash |
| `reviewer/silent-failure-hunter` | [reviewer](/plugins/reviewer) | Détecte les erreurs silencieuses, catch vides, et gestion d'erreurs inadéquate dans le code PHP. | Read, Grep, Glob, Bash |
| `tester/test-analyzer` | [tester](/plugins/tester) | Analyse la couverture et qualité des tests PHPUnit dans une PR. À utiliser de manière proactive avant de créer une PR pour identifier les tests manquants critiques. | Read, Grep, Glob, Bash |
| `tester/tester` | [tester](/plugins/tester) | Écrit les tests PHPUnit en approche TDD. Accès écriture aux fichiers de tests. À utiliser dans le cadre d'une équipe d'agents pour la phase d'implémentation. | Read, Write, Edit, Grep, Glob, Bash |
