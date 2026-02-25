#!/usr/bin/env bash
set -euo pipefail

# Génère le titre d'une Pull Request au format :
#   <emoji> <type>(<scope>): <description> [/ Issue #N]
#
# Usage:
#   generate_pr_title.sh [--issue <N>] [--no-issue] [--branch <name>]
#
# Options:
#   --issue <N>    Numéro d'issue à inclure dans le titre
#   --no-issue     Titre sans suffixe d'issue
#   --branch <name> Nom de branche (défaut : branche courante)
#
# Exit codes:
#   0  Titre généré avec succès
#   2  Numéro d'issue introuvable — l'appelant doit demander à l'utilisateur

# ─────────────────────────────────────────
# Prérequis
# ─────────────────────────────────────────
command -v git >/dev/null 2>&1 || { echo "git requis" >&2; exit 1; }

# ─────────────────────────────────────────
# Arguments
# ─────────────────────────────────────────
ISSUE_NUMBER=""
NO_ISSUE=false
BRANCH_NAME=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --issue)
            [[ -z "${2:-}" ]] && { echo "--issue requiert un numéro" >&2; exit 1; }
            ISSUE_NUMBER="$2"
            shift 2
            ;;
        --no-issue)
            NO_ISSUE=true
            shift
            ;;
        --branch)
            [[ -z "${2:-}" ]] && { echo "--branch requiert un nom de branche" >&2; exit 1; }
            BRANCH_NAME="$2"
            shift 2
            ;;
        *)
            echo "Option inconnue : $1" >&2
            exit 1
            ;;
    esac
done

# ─────────────────────────────────────────
# Nom de branche
# ─────────────────────────────────────────
if [[ -z "$BRANCH_NAME" ]]; then
    BRANCH_NAME=$(git branch --show-current)
    [[ -z "$BRANCH_NAME" ]] && { echo "Impossible de déterminer la branche courante" >&2; exit 1; }
fi

# ─────────────────────────────────────────
# Extraction du numéro d'issue depuis la branche
# Patterns supportés : feat/123-desc, fix/123_desc, feat/123/desc, feat-123-desc
# ─────────────────────────────────────────
if [[ -z "$ISSUE_NUMBER" ]] && [[ "$NO_ISSUE" == false ]]; then
    EXTRACTED=$(echo "$BRANCH_NAME" | grep -oE '[0-9]{1,6}' | head -1 || true)
    [[ -n "$EXTRACTED" ]] && ISSUE_NUMBER="$EXTRACTED"
fi

# Si toujours pas de numéro et pas --no-issue → demander à l'appelant
if [[ -z "$ISSUE_NUMBER" ]] && [[ "$NO_ISSUE" == false ]]; then
    echo "NO_ISSUE_FOUND" >&2
    exit 2
fi

# ─────────────────────────────────────────
# Analyse du dernier commit : type, scope, description
# On strip les emojis et caractères non-ascii en début de ligne
# ─────────────────────────────────────────
LAST_COMMIT=$(git log -1 --format="%s" HEAD 2>/dev/null || true)
CLEAN_COMMIT=$(echo "$LAST_COMMIT" | sed 's/^[^a-zA-Z]*//')

COMMIT_TYPE=""
COMMIT_SCOPE=""
COMMIT_DESC=""

# Utilise sed -E pour éviter les problèmes de parsing bash avec ')' dans les classes
COMMIT_TYPE=$(echo "$CLEAN_COMMIT" | sed -nE 's/^([a-zA-Z]+)(\([^)]*\))?: .*/\1/p')
COMMIT_SCOPE=$(echo "$CLEAN_COMMIT" | sed -nE 's/^[a-zA-Z]+\(([^)]*)\): .*/\1/p')
COMMIT_DESC=$(echo "$CLEAN_COMMIT" | sed -nE 's/^[a-zA-Z]+(\([^)]*\))?: (.*)/\2/p')

# Fallback sur le nom de branche si pas de type conventionnel
if [[ -z "$COMMIT_TYPE" ]]; then
    case "$BRANCH_NAME" in
        feat/*|feature/*)   COMMIT_TYPE="feat" ;;
        fix/*|hotfix/*|bugfix/*) COMMIT_TYPE="fix" ;;
        doc/*|docs/*)       COMMIT_TYPE="docs" ;;
        refactor/*|refacto/*) COMMIT_TYPE="refactor" ;;
        test/*|tests/*)     COMMIT_TYPE="test" ;;
        ci/*)               COMMIT_TYPE="ci" ;;
        *)                  COMMIT_TYPE="chore" ;;
    esac
    # Description depuis le nom de branche (strip type/, numéros et séparateurs)
    COMMIT_DESC=$(echo "$BRANCH_NAME" \
        | sed 's|^[^/]*/||' \
        | sed 's/^[0-9]*[-_]*//' \
        | sed 's/[-_]/ /g')
fi

# Guard : description vide
[[ -z "$COMMIT_DESC" ]] && COMMIT_DESC="$BRANCH_NAME"

# ─────────────────────────────────────────
# Mapping type → emoji
# ─────────────────────────────────────────
case "$COMMIT_TYPE" in
    feat|feature)        EMOJI="✨" ; COMMIT_TYPE="feat" ;;
    fix|bugfix|hotfix)   EMOJI="🐛" ; COMMIT_TYPE="fix" ;;
    docs|doc)            EMOJI="📝" ; COMMIT_TYPE="docs" ;;
    refactor|refacto)    EMOJI="♻️" ; COMMIT_TYPE="refactor" ;;
    test|tests)          EMOJI="✅" ; COMMIT_TYPE="test" ;;
    style)               EMOJI="💄" ;;
    perf)                EMOJI="⚡️" ;;
    ci)                  EMOJI="🚀" ;;
    revert)              EMOJI="⏪️" ;;
    chore)               EMOJI="🔧" ;;
    *)                   EMOJI="🔧" ; COMMIT_TYPE="chore" ;;
esac

# ─────────────────────────────────────────
# Construction du titre
# ─────────────────────────────────────────
if [[ -n "$COMMIT_SCOPE" ]]; then
    BASE_TITLE="${EMOJI} ${COMMIT_TYPE}(${COMMIT_SCOPE}): ${COMMIT_DESC}"
else
    BASE_TITLE="${EMOJI} ${COMMIT_TYPE}: ${COMMIT_DESC}"
fi

if [[ -n "$ISSUE_NUMBER" ]]; then
    echo "${BASE_TITLE} / Issue #${ISSUE_NUMBER}"
else
    echo "${BASE_TITLE}"
fi
