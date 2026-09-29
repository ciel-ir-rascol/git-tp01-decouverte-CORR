# Correction — TP01 Découverte de Git et GitHub

**⚠️ Dossier enseignant — ne jamais publier ni pousser sur le dépôt étudiant.**

Ce dossier accompagne le dépôt public `git-tp01-decouverte`, distribué aux étudiants via GitHub. Le TP suit le cours `git-cours01-decouverte` (slides + document à trous, corrigé dans `git-cours01-decouverte-CORR`).

## Contenu

| Fichier | Description |
| --- | --- |
| [CORRECTION.md](CORRECTION.md) | Corrigé complet : réponses, sorties de référence, erreurs fréquentes, barème indicatif /20 |
| [scripts/solution.sh](scripts/solution.sh) | Réalise tout le TP automatiquement (parties 0 à 7 + bonus 2), en affichant chaque commande et sa sortie |
| [scripts/test-docker.sh](scripts/test-docker.sh) | Banc de test : poste vierge → `verifier.sh` → `solution.sh` → `verifier.sh` |
| `../git-tp01-decouverte/scripts/verifier.sh` | Auto-vérification (25 contrôles) : il vit dans le **dépôt étudiant**, dont il fait partie |

> [!WARNING]
> `solution.sh` modifie `~/.gitconfig` et crée `~/.ssh/id_ed25519` : il refuse de se lancer hors d'un conteneur. Ne pas le forcer (`SOLUTION_FORCER=1`) sur votre poste.

## Déroulé conseillé (3h, après le cours de 1h)

| Temps | Parties | Remarques |
| --- | --- | --- |
| 0h00 – 0h35 | 0 → 2 | La création des comptes GitHub est le goulot d'étranglement : vérification par e-mail, énigme, parfois lente si toute la classe s'inscrit en même temps (même IP). Faire commencer la partie 2 pendant l'attente du code. |
| 0h35 – 1h45 | 3 → 4 | Cœur du TP, en autonomie. Passer vérifier les messages de commit et la structure de `COMPTE-RENDU.md` dès la 3.6. |
| 1h45 – 2h10 | 5 | Faire une démonstration collective de la copie de la clé publique au vidéoprojecteur : c'est là que les erreurs sont les plus graves (clé privée copiée). |
| 2h10 – 3h00 | 6 → 7 | Le script de vérification (7.3) sert de « ticket de sortie ». Récupérer les URL des dépôts. |

Les étudiants rapides font les bonus. Le bonus 2 (conflit) prépare bien le TP suivant.

## Préparation avant la séance

1. **Publier le dépôt étudiant** sur `ciel-ir-rascol/git-tp01-decouverte` (**public** : les étudiants le lisent et le clonent en HTTPS **avant** d'avoir un compte ou une clé).
2. **Postes** : Ubuntu Desktop 24.04, `git` et `openssh-client` installés (c'est le cas par défaut pour `ssh`). Vérifier que :
   - le **port 22 sortant vers `github.com`** n'est pas filtré par le pare-feu du lycée. Sinon, GitHub accepte SSH sur le port 443 : ajouter dans `~/.ssh/config` :
     ```text
     Host github.com
         Hostname ssh.github.com
         Port 443
         User git
     ```
   - le **dossier personnel est persistant** d'une séance à l'autre (clé SSH, `~/.gitconfig`, `~/tp-git`). Sinon, prévenir les étudiants qu'il faudra régénérer la clé à chaque séance, et privilégier `git push` systématique en fin de séance.
3. **Inscriptions GitHub** : beaucoup de créations de comptes depuis la même IP publique peuvent déclencher des vérifications supplémentaires côté GitHub. Si possible, faire créer les comptes **à la maison avant la séance** (la partie 1 est lisible sans compte).
4. **Téléphones** : la 2FA sera réclamée par GitHub dans les semaines suivantes ; prévenir les étudiants.

## Validation

| Élément | État |
| --- | --- |
| `verifier.sh` | ✅ Testé dans Ubuntu 24.04 (Docker) : échec immédiat sur poste vierge, **24/25** après `solution.sh` |
| Comportements décrits dans le sujet | ✅ `git status` hors dépôt, zones, `diff`, `restore`, `restore --staged`, `.gitignore`, `show hash:fichier`, `status` « up to date » malgré un commit distant (6.4 a), `pull` en *fast-forward*, `push` refusé (*fetch first*), message *divergent branches*, conflit et fusion |
| Authentification SSH auprès de GitHub, pages web de GitHub, 2FA | ⚠️ **Non testés** : GitHub est simulé par des dépôts nus locaux (`url.<base>.insteadOf`). C'est le seul contrôle en échec du banc de test. À vérifier avec un vrai compte avant la séance. |
| Messages de Git en français | ⚠️ Le conteneur affiche les messages en anglais. Les sorties de `CORRECTION.md` sont donc en anglais ; vérifier sur un poste du lycée. |

Pour relancer le banc de test après une modification du sujet ou de `verifier.sh` :

```bash
cd scripts && ./test-docker.sh
```

Les sorties de chaque étape sont écrites dans `scripts/solution.log`, ignoré par Git.

## Licence

[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)
