# Règles de rédaction des notes de release

## Principe fondamental

Les notes de release s'adressent aux **utilisateurs finaux**, pas aux développeurs.
Transformer les messages techniques en bénéfices concrets et compréhensibles.

## Les 4 règles absolues

### 1. Zéro jargon technique
Ne jamais utiliser : API, SQL, cache, endpoint, refactoring, regex, migration, heap, stack, buffer, mutex, thread, async, payload, webhook...

### 2. Parler en bénéfices utilisateur
| ❌ Commit technique | ✅ Note utilisateur |
|---------------------|---------------------|
| feat: implémenter cache Redis | L'application s'ouvre plus rapidement |
| fix: corriger validation email | Certaines adresses email sont maintenant acceptées |
| perf: optimiser requêtes SQL | Les pages se chargent plus vite |
| feat: ajouter pagination | Vous pouvez naviguer entre les pages de résultats |
| fix: corriger fuite mémoire | L'application est plus stable lors d'une utilisation prolongée |

### 3. Verbes d'action à la première personne du pluriel
- "Vous pouvez maintenant..."
- "Nous avons corrigé..."
- "Il est désormais possible de..."
- "L'application affiche maintenant..."

### 4. Phrases courtes
- Maximum 1-2 phrases par item
- Une idée = une phrase

## Catégories

| Catégorie | Commits inclus | Icône |
|-----------|----------------|-------|
| Nouveautés | `feat:` | ⭐ |
| Améliorations | `improve:`, `perf:` | 📈 |
| Corrections | `fix:` | ✅ |
| Sécurité | tout ce qui touche auth, perms, CVE | 🔒 |

## Commits à ignorer

Ces types ne génèrent pas de notes :
- `refactor:` — interne, invisible pour l'utilisateur
- `test:` — interne
- `chore:` — maintenance
- `ci:` — pipeline
- `docs:` — documentation interne
- `style:` — formatage
- Commits de merge (`Merge branch`, `Merge pull request`)
- Bumps de dépendances (`bump X from Y to Z`)

## Exemples complets

### Exemple 1 — feat
Commit : `feat(auth): ajouter authentification OAuth Google`
Note : "Vous pouvez maintenant vous connecter avec votre compte Google."

### Exemple 2 — fix
Commit : `fix(upload): corriger la limite de taille des fichiers uploadés`
Note : "Nous avons corrigé un problème qui empêchait l'envoi de certains fichiers."

### Exemple 3 — perf
Commit : `perf: optimiser le chargement de la liste des commandes`
Note : "La liste de vos commandes se charge maintenant beaucoup plus rapidement."

### Exemple 4 — sécurité
Commit : `fix(auth): corriger faille dans la validation des tokens`
Note : "Nous avons renforcé la sécurité de votre connexion."
