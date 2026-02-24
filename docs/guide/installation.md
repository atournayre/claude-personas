---
title: Installation
---

# Installation

## Cloner le repository

```bash
git clone https://github.com/atournayre/claude-personas.git
```

## Installer un persona

Copie le persona voulu dans ton dossier de plugins Claude Code :

```bash
# Installation globale (disponible dans tous les projets)
cp -r claude-personas/analyst ~/.claude/plugins/analyst

# Ou installation locale (spécifique à un projet)
cp -r claude-personas/analyst .claude/plugins/analyst
```

## Installer plusieurs personas

```bash
for persona in analyst architect reviewer; do
  cp -r claude-personas/$persona ~/.claude/plugins/$persona
done
```

## Vérifier l'installation

Les commandes du persona doivent apparaître dans Claude Code :

```
/analyst:discover
/analyst:explore
```

## Mise à jour

```bash
cd claude-personas
git pull

# Réinstaller le persona mis à jour
cp -r analyst ~/.claude/plugins/analyst
```

## Dépendances optionnelles

Certains personas utilisent des plugins externes :

| Persona | Dépendance | Usage |
|---------|-----------|-------|
| analyst | gemini | Agent `gemini-analyzer` |
| architect | gemini | Agent `deep-think` |
| php | symfony | Makers Symfony |
| researcher | gemini | Skills `analyze` et `search` |
