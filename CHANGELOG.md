# Changelog - Claude Personas

Toutes les modifications notables de ce marketplace sont documentées ici.

Format basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/).
Versioning via [Semantic Versioning](https://semver.org/lang/fr/).

## [Unreleased]

### Plugins Added
- **symfony v1.0.0** - Expert Symfony couvrant le framework core et l'écosystème officiel (150+ bundles)
  - `symfony:console` — Génération de commandes console
  - `symfony:controller` — Génération de contrôleurs avec routing attributs
  - `symfony:form` — Génération de FormType avec validation
  - `symfony:event` — Génération d'Event + EventSubscriber/Listener
  - `symfony:message` — Génération de Message Messenger + Handler
  - `symfony:voter` — Génération de Voter de sécurité
  - `symfony:mailer` — Génération de TemplatedEmail / Notification
  - `symfony:config` — Assistant de configuration de bundles
  - `symfony:diagnose` — Diagnostic d'applications Symfony
  - Agents : `symfony-expert`, `security-auditor`
  - [symfony/CHANGELOG.md](symfony/CHANGELOG.md)
- **twig v1.0.0** - Persona Twig/Symfony UX avec skill make-component
  - `twig:make-component` — Génération de Twig Components (standard et anonymous)
  - [twig/CHANGELOG.md](twig/CHANGELOG.md)

### Plugins Updated
- **devops v1.1.2** - Centralisation scripts et correction des références
  - Scripts centralisés dans `devops/scripts/` (copiés depuis claude-plugin)
  - Script `generate_pr_title.sh` pour mutualiser la génération de titres PR
  - Correction de toutes les références `CORE_SCRIPTS` dans les SKILL.md
  - [devops/CHANGELOG.md](devops/CHANGELOG.md)
- **devops v1.1.1** - Skills PR avec suffixe Issue #NUMERO
  - Ajouter suffixe " / Issue #NUMERO" au titre des PR pour tracer la relation avec l'issue liée
  - [devops/CHANGELOG.md](devops/CHANGELOG.md)

## [1.1.0] - 2025-01-01

### Plugins Updated
- **analyst v1.1.0** - [analyst/CHANGELOG.md](analyst/CHANGELOG.md)
- **architect v1.1.0** - [architect/CHANGELOG.md](architect/CHANGELOG.md)
- **devops v1.1.0** - [devops/CHANGELOG.md](devops/CHANGELOG.md)
- **documenter v1.1.0** - [documenter/CHANGELOG.md](documenter/CHANGELOG.md)
- **implementer v1.1.0** - [implementer/CHANGELOG.md](implementer/CHANGELOG.md)
- **infra v1.1.0** - [infra/CHANGELOG.md](infra/CHANGELOG.md)
- **orchestrator v1.1.0** - [orchestrator/CHANGELOG.md](orchestrator/CHANGELOG.md)
- **php v1.1.0** - [php/CHANGELOG.md](php/CHANGELOG.md)
- **researcher v1.1.0** - [researcher/CHANGELOG.md](researcher/CHANGELOG.md)
- **reviewer v1.1.0** - [reviewer/CHANGELOG.md](reviewer/CHANGELOG.md)
- **tester v1.1.0** - [tester/CHANGELOG.md](tester/CHANGELOG.md)