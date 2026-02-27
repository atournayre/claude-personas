## [1.1.3] - 2026-02-27

### Fixed
- Créer les PR en mode Draft pour limiter l'exécution de la CI au démarrage

## [1.1.2] - 2026-02-25

### Added
- Scripts centralisés dans `devops/scripts/` (scripts copiés depuis claude-plugin)
- Script `generate_pr_title.sh` : génération mutualisée des titres PR avec emoji et lien issue optionnel
- Fichiers de référence pour `devops:release-notes` (html-template.html, writing-rules.md)

### Fixed
- Correction de toutes les références `CORE_SCRIPTS` dans les SKILL.md (branch, worktree, pr, cd-pr, ci-autofix, release-notes)

## [1.1.1] - 2026-02-25

### Changed
- Skill `devops:pr` : ajouter suffixe " / Issue #NUMERO" au titre des PR
- Skill `devops:cd-pr` : ajouter suffixe " / Issue #NUMERO" au titre des PR

## [1.1.0] - 2026-02-20

### Added
- Release for marketplace

### Changed
- Documentation updates

# Changelog - devops

## [1.0.0] - 2026-02-19

### Added
- Skill `devops:branch` : création de branche Git structurée (issu de git:branch + git:branch-core, fusionnés)
- Skill `devops:commit` : commits conventionnels avec emoji (issu de git:commit)
- Skill `devops:worktree` : gestion worktrees Git (issu de git:worktree + dev:worktree, fusionnés)
- Skill `devops:conflict` : résolution interactive de conflits (issu de git:conflit)
- Skill `devops:pr` : création PR GitHub standard (issu de git:git-pr)
- Skill `devops:cd-pr` : création PR Continuous Delivery (issu de git:git-cd-pr)
- Skill `devops:ci-autofix` : correction automatique erreurs CI (issu de git:ci-autofix)
- Skill `devops:release-report` : rapport HTML d'impact de release (issu de git:release-report)
- Skill `devops:release-notes` : notes de release orientées utilisateurs (issu de git:gen-release-notes)

### Notes
- Les scripts shell restent dans le plugin `git` (déprécié mais disponible)
- Les SKILL.md référencent ces scripts via `${CLAUDE_PLUGIN_ROOT}/../git/skills/*/scripts/`
