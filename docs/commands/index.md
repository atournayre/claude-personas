---
title: Index des Skills
---

# Index des Skills

74 skills disponibles dans le marketplace.

**Note** : Les skills sont invoquées via slash commands (ex: `/git:commit`, `/dev:feature`). ⚠️ = plugin déprécié.

| Skill | Plugin | Description |
|-------|--------|-------------|
| `/analyst:clarify` | [analyst](/plugins/analyst) | Lever les ambiguïtés avant design - Phase 2 (mode interactif ou heuristiques automatiques) |
| `/analyst:discover` | [analyst](/plugins/analyst) | Comprendre le besoin avant développement - Phase 0 (supporte le mode automatique) |
| `/analyst:explore` | [analyst](/plugins/analyst) | Explorer le codebase avec agents parallèles - Phase 1 (supporte le mode automatique) |
| `/analyst:impact` | [analyst](/plugins/analyst) | Génère automatiquement deux rapports d'impact (métier et technique) pour une PR GitHub et les intègre dans la description |
| `/api-platform:audit` | [api-platform](/plugins/api-platform) | Audite un projet API Platform existant et produit un rapport de bonnes pratiques, performances et sécurité |
| `/api-platform:make-dto` | [api-platform](/plugins/api-platform) | Génère des DTOs (input/output) API Platform avec mapping vers les entités |
| `/api-platform:make-filter` | [api-platform](/plugins/api-platform) | Génère des filtres API Platform (search, date, range, order, boolean, exists, custom) |
| `/api-platform:make-processor` | [api-platform](/plugins/api-platform) | Génère un State Processor API Platform pour personnaliser la persistence des données |
| `/api-platform:make-provider` | [api-platform](/plugins/api-platform) | Génère un State Provider API Platform pour personnaliser la récupération de données |
| `/api-platform:make-resource` | [api-platform](/plugins/api-platform) | Génère une API Resource complète avec attribut #[ApiResource], opérations, groupes de sérialisation et configuration |
| `/api-platform:make-test` | [api-platform](/plugins/api-platform) | Génère des tests fonctionnels API Platform (PHPUnit/ApiTestCase) pour une resource |
| `/architect:adr` | [architect](/plugins/architect) | Génère un Architecture Decision Record (ADR) formaté et structuré |
| `/architect:design` | [architect](/plugins/architect) | Designer des approches architecturales et choisir la meilleure - Phase 3 (supporte le mode automatique) |
| `/architect:plan` | [architect](/plugins/architect) | Générer plan d'implémentation détaillé dans docs/specs/ - Phase 4 (supporte le mode automatique) |
| `/architect:start` | [architect](/plugins/architect) | Démarre un développement avec un starter léger puis active le mode plan |
| `/bump` | marketplace | Automatise les mises à jour de version des plugins avec détection automatique du type de version |
| `/devops:branch` | [devops](/plugins/devops) | Création de branche Git avec workflow structuré |
| `/devops:cd-pr` | [devops](/plugins/devops) | > |
| `/devops:ci-autofix` | [devops](/plugins/devops) | Parse les logs CI et corrige automatiquement les erreurs |
| `/devops:commit` | [devops](/plugins/devops) | Créer des commits bien formatés avec format conventional et emoji |
| `/devops:conflict` | [devops](/plugins/devops) | Analyse les conflits git et propose à l'utilisateur une résolution pas à pas avec validation de chaque étape. |
| `/devops:pr` | [devops](/plugins/devops) | > |
| `/devops:release-notes` | [devops](/plugins/devops) | > |
| `/devops:release-report` | [devops](/plugins/devops) | Génère un rapport HTML d'analyse d'impact entre deux branches |
| `/devops:worktree` | [devops](/plugins/devops) | Gestion des git worktrees pour développement parallèle (création, liste, suppression, statut, switch) |
| `/documenter:claude-load` | [documenter](/plugins/documenter) | Charge la documentation Claude Code depuis docs.claude.com dans des fichiers markdown locaux |
| `/documenter:claude-question` | [documenter](/plugins/documenter) | Interroger la documentation Claude Code locale pour répondre à une question |
| `/documenter:load` | [documenter](/plugins/documenter) | > |
| `/documenter:rtfm` | [documenter](/plugins/documenter) | Lit la documentation technique - RTFM (Read The Fucking Manual) |
| `/documenter:summary` | [documenter](/plugins/documenter) | Résumé de ce qui a été construit (Phase 7 du workflow de développement) |
| `/documenter:update` | [documenter](/plugins/documenter) | Crées la documentation pour la fonctionnalité en cours. Mets à jour le readme global du projet si nécessaire. Lie les documents entre eux pour ne pas avoir de documentation orpheline. La documentation est générée dans les répertoire de documentation du projet. |
| `/implementer:code` | [implementer](/plugins/implementer) | Implémenter selon le plan — avec ou sans approbation préalable |
| `/implementer:debug` | [implementer](/plugins/implementer) | Analyser et résoudre une erreur (message simple ou stack trace) |
| `/implementer:fix-issue` | [implementer](/plugins/implementer) | Corriger une issue GitHub avec workflow structuré et efficace |
| `/implementer:fix-pr-comments` | [implementer](/plugins/implementer) | Récupérer les commentaires de review PR et implémenter tous les changements demandés |
| `/implementer:implement` | [implementer](/plugins/implementer) | Forcer l'implémentation complète d'une feature (pas juste planification) |
| `/implementer:log` | [implementer](/plugins/implementer) | Ajouter LoggableInterface à une classe PHP |
| `/implementer:oneshot` | [implementer](/plugins/implementer) | Implémentation ultra-rapide d'une feature ciblée — Explore, Code, Test |
| `/implementer:refactor` | [implementer](/plugins/implementer) | Refactoring autonome piloté par les tests — boucle refactor/test/ajust |
| `/infra:alias-add` | [infra](/plugins/infra) | Crée un alias de slash command qui délègue à une autre slash command existante. Valide les arguments, crée le fichier d'alias, et met à jour la documentation. |
| `/infra:bump` | [infra](/plugins/infra) | Automatise les mises à jour de version des plugins avec détection automatique du type (PATCH ou MINOR). Met à jour plugin.json, CHANGELOG, README du plugin, README global, CHANGELOG global, marketplace.json, template PR et documentation VitePress. |
| `/infra:fix-grammar` | [infra](/plugins/infra) | Corrige les fautes de grammaire et d'orthographe dans un ou plusieurs fichiers en préservant le formatage, la structure et les termes techniques. Traitement parallèle pour plusieurs fichiers. |
| `/infra:init` | [infra](/plugins/infra) | Initialise le marketplace et vérifie toutes les dépendances nécessaires aux plugins (git, gh, node, npm, bun). Génère un rapport avec les dépendances installées/manquantes et les commandes d'installation. |
| `/infra:make-subagent` | [infra](/plugins/infra) | Guide expert pour créer et configurer des sous-agents Claude Code spécialisés. Couvre la structure des fichiers agent, le frontmatter, les prompts système, les outils, les modes background et les patterns d'orchestration. Utiliser pour créer de nouveaux agents ou configurer des workflows multi-agents. |
| `/infra:memory` | [infra](/plugins/infra) | Crée et optimise les fichiers de mémoire Claude Code (CLAUDE.md ou .claude/rules/). Couvre la hiérarchie de fichiers, la structure du contenu, les règles path-scoped, les bonnes pratiques et les anti-patterns. Utiliser pour CLAUDE.md, .claude/rules/, nouveaux projets, ou améliorer la conscience contextuelle. |
| `/infra:skill-creator` | [infra](/plugins/infra) | Guide expert pour créer des skills Claude Code efficaces. Couvre la structure SKILL.md, le frontmatter, les ressources bundlées (scripts, references, assets), la progressive disclosure et les bonnes pratiques. Utiliser quand l'utilisateur demande de créer ou améliorer un skill. |
| `/orchestrator:check-prerequisites` | [orchestrator](/plugins/orchestrator) | Vérifie tous les prérequis système avant de lancer un workflow automatique (gh CLI, jq, git). Exit code 1 si un prérequis manque. |
| `/orchestrator:feature` | [orchestrator](/plugins/orchestrator) | Workflow complet de développement de feature. Mode interactif (description texte) avec 8 phases et checkpoints utilisateur. Mode automatique (numéro issue GitHub) avec 10 phases sans interaction. Utilise worktrees, task management et agents spécialisés. |
| `/orchestrator:fetch-issue` | [orchestrator](/plugins/orchestrator) | Récupère et valide le contenu d'une issue GitHub pour le workflow automatique. Vérifie que l'issue est OPEN et a une description non vide. |
| `/orchestrator:parallel` | [orchestrator](/plugins/orchestrator) | Implémentation parallèle de N issues GitHub via worktrees isolés. Chaque issue est traitée par un agent indépendant. Max 3 agents simultanés. |
| `/orchestrator:ralph` | [orchestrator](/plugins/orchestrator) | Setup du loop autonome de développement Ralph. Crée la structure .claude/ralph/, génère le PRD interactivement ou pour une feature spécifique, et affiche la commande à exécuter. NE lance jamais ralph.sh automatiquement. |
| `/orchestrator:status` | [orchestrator](/plugins/orchestrator) | Affiche l'état actuel du workflow de développement (phases complétées, en cours, à faire) avec timings depuis le fichier d'état. |
| `/orchestrator:team` | [orchestrator](/plugins/orchestrator) | Orchestre une équipe d'agents spécialisés pour les tâches complexes. Auto-détecte le type (feature/refactor/api/fix), compose l'équipe, coordonne les phases analyse -> challenge -> implémentation -> QA. |
| `/orchestrator:transform` | [orchestrator](/plugins/orchestrator) | Transforme un prompt quelconque (texte libre ou fichier) en prompt exécutable structuré avec TaskCreate/TaskUpdate/TaskList. Génère un fichier .claude/prompts/executable-{name}-{timestamp}.md |
| `/orchestrator:validate` | [orchestrator](/plugins/orchestrator) | Vérifie la checklist (PHP, API ou sécurité) avant exécution. Effectue les vérifications automatiques (PHPStan, PSR-12, tests, Elegant Objects, sécurité) et liste les points à vérifier manuellement. |
| `/php:make-all` | [php](/plugins/php) | Génère tous les fichiers pour une entité complète (orchestrateur) |
| `/php:make-collection` | [php](/plugins/php) | Génère classe Collection typée avec traits Atournayre |
| `/php:make-contracts` | [php](/plugins/php) | Génère les interfaces de contrats pour une architecture Elegant Objects |
| `/php:make-entity` | [php](/plugins/php) | Génère une entité Doctrine avec repository selon principes Elegant Objects |
| `/php:make-factory` | [php](/plugins/php) | Génère Factory Foundry pour tests |
| `/php:make-invalide` | [php](/plugins/php) | Génère classe Invalide (exceptions métier) |
| `/php:make-out` | [php](/plugins/php) | Génère classe Out (DTO immuable pour output) |
| `/php:make-story` | [php](/plugins/php) | Génère Story Foundry pour fixtures de tests |
| `/php:make-urls` | [php](/plugins/php) | Génère classe Urls + Message CQRS + Handler |
| `/researcher:analyze` | [researcher](/plugins/researcher) | Analyse une codebase ou documentation avec Gemini (1M tokens) |
| `/researcher:search` | [researcher](/plugins/researcher) | Recherche temps réel via Google Search intégré à Gemini |
| `/reviewer:challenge` | [reviewer](/plugins/reviewer) | Évaluer la dernière réponse Claude, donner une note sur 10 et proposer des améliorations |
| `/reviewer:elegant-objects` | [reviewer](/plugins/reviewer) | Vérifier la conformité du code PHP aux principes Elegant Objects de Yegor Bugayenko |
| `/reviewer:phpstan` | [reviewer](/plugins/reviewer) | Résoudre automatiquement les erreurs PHPStan niveau 9 — boucle jusqu'à zéro erreur |
| `/reviewer:review` | [reviewer](/plugins/reviewer) | Review qualité complète — PHPStan + Elegant Objects + code review + adversarial |
| `/symfony:config` | [symfony](/plugins/symfony) | Assistant de configuration de bundles Symfony — aide a configurer n'importe quel bundle officiel |
| `/symfony:console` | [symfony](/plugins/symfony) | Genere une commande console Symfony avec arguments, options et interaction |
| `/symfony:controller` | [symfony](/plugins/symfony) | Genere un controleur Symfony avec routing attributs et bonnes pratiques |
| `/symfony:diagnose` | [symfony](/plugins/symfony) | Diagnostique les problemes d'une application Symfony — erreurs, performances, configuration |
| `/symfony:event` | [symfony](/plugins/symfony) | Genere un Event Symfony + EventSubscriber ou EventListener |
| `/symfony:form` | [symfony](/plugins/symfony) | Genere un FormType Symfony avec contraintes de validation et options |
| `/symfony:mailer` | [symfony](/plugins/symfony) | Genere un email Symfony (TemplatedEmail ou Notification) avec template Twig |
| `/symfony:message` | [symfony](/plugins/symfony) | Genere un Message Symfony Messenger avec son Handler pour traitement asynchrone |
| `/symfony:voter` | [symfony](/plugins/symfony) | Genere un Voter de securite Symfony pour le controle d'acces granulaire |
| `/tester:ui-test` | [tester](/plugins/tester) | > |
| `/twig:make-component` | [twig](/plugins/twig) | Génère un Twig Component Symfony UX (classe PHP + template Twig) |
