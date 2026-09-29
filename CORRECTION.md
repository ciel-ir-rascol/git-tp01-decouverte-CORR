# Corrigé — TP01 Découverte de Git et GitHub

Les sorties de référence ci-dessous proviennent du banc de test (`scripts/test-docker.sh`, Ubuntu 24.04, Git 2.43.0). Elles sont en **anglais** : le conteneur n'a pas les traductions de Git. Sur un poste en français, les messages peuvent être traduits (`Sur la branche main`, `Fichiers non suivis`…). Seuls les hashs, les dates et les chemins changent d'un étudiant à l'autre.

Dans le banc de test, `git remote -v` affiche un chemin local (GitHub est simulé). Sur un vrai poste, il affiche `git@github.com:PSEUDO/tp01-git.git`.

---

## Barème indicatif (/20)

| Partie | Attendus | Points |
| :---: | --- | :---: |
| 0 – 2 | Version de Git, URL du profil, configuration correcte, rôle de `--global` | 2 |
| 3 | Questions 3.1 à 3.8 : zones identifiées, `git log` commenté, hash (40 hexa, 160 bits), deux commits séparés | 5 |
| 4 | `git show`, `restore`, `restore --staged`, `.gitignore`, lecture d'une ancienne version | 4 |
| 5 | Clé ed25519 créée, permissions expliquées, `ssh -T` réussi, publique / privée expliqué | 3 |
| 6 | Dépôt publié en SSH, commit web récupéré par `pull`, schéma de la chaîne complet | 3 |
| 7 | Clone, aller-retour maison / lycée, script de vérification au vert | 2 |
| — | Qualité des commits (nombre, messages clairs, un commit = une idée) | 1 |
| | | **/20** |

Le script `verifier.sh` du dépôt étudiant (25 contrôles) couvre l'essentiel de la partie « technique ». Les explications (« pourquoi ») se corrigent dans `COMPTE-RENDU.md`.

---

## Partie 0 — Préparer son poste

### Question 0

```text
$ git --version
git version 2.43.0
```

Git **2.43.0** sur Ubuntu 24.04 LTS (paquet de la distribution).

---

## Partie 1 — Compte GitHub

### Question 1

URL de la forme `https://github.com/lea-martin`.

Points de vigilance à vérifier en passant dans les rangs :

- **pseudo** sobre et durable (pas d'année, pas de référence au lycée) ;
- **e-mail personnel** (l'adresse du lycée expire) ;
- **2FA** : GitHub la réclame dans les 45 jours. Insister sur les **codes de récupération**, sinon un téléphone perdu = un compte perdu (le support GitHub ne rétablit pas l'accès).

---

## Partie 2 — Se présenter à Git

### Question 2

```text
$ git config --list --global
user.name=Léa Martin
user.email=lea.martin@exemple.fr
init.defaultbranch=main
core.editor=nano
```

1. Sortie ci-dessus. Remarque : Git affiche les clés en minuscules (`init.defaultbranch`).
2. `--global` : le réglage s'applique à **tous les dépôts de l'utilisateur** sur ce poste. Il est enregistré dans **`~/.gitconfig`**. (Sans option, le réglage ne vaudrait que pour le dépôt courant, dans `.git/config`.)

```text
$ cat ~/.gitconfig
[user]
	name = Léa Martin
	email = lea.martin@exemple.fr
[init]
	defaultBranch = main
[core]
	editor = nano
```

---

## Partie 3 — Premier dépôt, premiers commits

### Question 3.1

```text
$ git status
fatal: not a git repository (or any of the parent directories): .git
```

Le dossier n'est **pas un dépôt** : Git cherche un dossier `.git/` dans le dossier courant et ses parents, et n'en trouve pas.

### Question 3.2

```text
$ git init
Initialized empty Git repository in /home/etudiant/tp-git/tp01-git/.git/
$ ls -la
drwxr-xr-x 7 etudiant etudiant 4096 sept. 29 09:03 .git
$ git status
On branch main

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

1. `git init` crée le dossier **`.git/`**. Son nom commence par un point : c'est un **fichier caché**, que `ls` n'affiche qu'avec l'option `-a`.
2. Le dossier est maintenant un dépôt, sur la branche `main`, sans aucun commit.

### Question 3.3

```text
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	README.md
```

`README.md` est **non suivi** (*untracked*) : il est seulement dans le **répertoire de travail**. Git ne le connaît pas encore.

### Question 3.4

```text
Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
	new file:   README.md
```

Le fichier est passé dans la section « à valider » (*Changes to be committed*, en vert) : il est dans la **zone de préparation**.

### Question 3.5

```text
$ git commit -m "Création du README"
[main (root-commit) 8fd6812] Création du README
 1 file changed, 5 insertions(+)
 create mode 100644 README.md
$ git log
commit 8fd681287ceb283e8153ab57436093354b6227b9
Author: Léa Martin <lea.martin@exemple.fr>
Date:   Tue Sep 29 09:03:21 2026 +0000

    Création du README
```

1. Sortie ci-dessus.
2. Hash `8fd68128…` (propre à chaque étudiant), auteur `Léa Martin <lea.martin@exemple.fr>`, date, message `Création du README`.
3. **40 caractères**, en **hexadécimal** (chiffres 0-9 et lettres a-f). Un chiffre hexadécimal code 4 bits : 40 × 4 = **160 bits** (hash SHA-1). Lien avec le TD02 de maths.

`root-commit` : c'est le premier commit, il n'a pas de parent.

### Question 3.6 (pas de question)

Vérifier que `COMPTE-RENDU.md` est structuré en titres `## Question …` et que les sorties sont dans des blocs de code.

### Question 3.7

```text
$ git status
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   README.md
$ git diff
@@ -3,3 +3,4 @@
 Dépôt réalisé par Léa Martin, 1CIEL-IR.
 
 Ce dépôt contient mon compte rendu du TP01.
+Année scolaire 2026-2027.
```

1. `README.md` est **modifié** (*modified*), mais la modification n'est **pas encore préparée** (*not staged*, en rouge).
2. `git diff` montre les différences entre le répertoire de travail et la dernière version connue de Git (zone de préparation). Le `+` marque une **ligne ajoutée** (un `-` marquerait une ligne supprimée). Les lignes sans signe sont le contexte.

### Question 3.8

```text
$ git log --oneline
43cb3a0 Question 3.7
f8a734e Création de l'aide-mémoire Git
874f977 Ajout de l'année scolaire dans le README
7f6d958 Ajout du compte rendu (questions 0 à 3.5)
8fd6812 Création du README
```

2. **Un commit = une idée.** Deux commits séparés permettent de comprendre l'historique (chaque message décrit une seule modification), de retrouver facilement une modification, et d'**annuler l'une sans l'autre**. Un `git add .` risque aussi d'embarquer des fichiers non voulus.

---

## Partie 4 — Explorer l'historique et réparer ses erreurs

### Question 4.1

`git show <hash>` affiche les **métadonnées** du commit (hash complet, auteur, date, message) **et les modifications** qu'il apporte, au format de `git diff` (ici, la ligne `+Année scolaire 2026-2027.`).

### Question 4.2

```text
$ git restore README.md
$ cat README.md
# TP01 — Découverte de Git
...
Année scolaire 2026-2027.
```

`git restore` **remplace le fichier du répertoire de travail par la dernière version enregistrée** (celle de la zone de préparation, donc ici celle du dernier commit). La modification « oups » est **définitivement perdue**.

Un fichier **jamais commité** (ni même ajouté avec `git add`) est inconnu de Git : **impossible** de le récupérer ainsi. D'où l'intérêt de committer souvent.

### Question 4.3

```text
$ git restore --staged test.txt
$ git status
Untracked files:
	test.txt
```

`test.txt` revient dans le **répertoire de travail** (non suivi). Il n'est **pas supprimé** du disque : `--staged` retire seulement le fichier de la zone de préparation.

### Question 4.4

```text
$ git status          # après création du .gitignore
Untracked files:
	.gitignore
```

1. `brouillon.txt`, `test.txt`, `erreurs.log` et `debug.log` disparaissent. `*.log` est un **motif** : `*` remplace n'importe quelle suite de caractères, donc tous les fichiers se terminant par `.log` sont ignorés.
2. Le fichier **`.gitignore`** lui-même apparaît. **Oui**, il faut le committer : il fait partie du projet, et toute personne qui clonera le dépôt profitera des mêmes règles.

### Question 4.5

```text
$ git show 8fd6812:README.md
# TP01 — Découverte de Git

Dépôt réalisé par Léa Martin, 1CIEL-IR.

Ce dépôt contient mon compte rendu du TP01.
$ git diff 8fd6812 HEAD -- README.md
+Année scolaire 2026-2027.
```

Le premier README ne contenait pas la ligne « Année scolaire 2026-2027. », ajoutée depuis. (Les étudiants rapides qui auraient déjà fait la partie 6 verront aussi la ligne ajoutée depuis GitHub.)

---

## Partie 5 — Clé SSH

### Question 5.2

```text
$ ls -l ~/.ssh/
-rw------- 1 etudiant etudiant 411 sept. 29 09:03 id_ed25519
-rw-r--r-- 1 etudiant etudiant 103 sept. 29 09:03 id_ed25519.pub
```

1. `id_ed25519` = clé **privée**, `id_ed25519.pub` = clé **publique**. (S'y ajoute `known_hosts` après la première connexion à GitHub.)
2. Clé privée en **600** (`rw-------`) : lisible et modifiable **par son propriétaire uniquement**. C'est un secret : SSH **refuse** d'utiliser une clé privée lisible par d'autres (`UNPROTECTED PRIVATE KEY FILE`). La clé publique est en 644 : tout le monde peut la lire, ce n'est pas un problème.

### Question 5.4

```text
$ ssh -T git@github.com
Hi lea-martin! You've successfully authenticated, but GitHub does not provide shell access.
```

2. La clé publique ne permet que de **vérifier** une signature, pas d'en **produire** une : la donner ne permet pas de se faire passer pour moi (analogie du cadenas ouvert). La clé privée, elle, permet de **répondre au défi** de GitHub : celui qui la possède peut se faire passer pour moi et pousser dans mes dépôts.

Erreurs fréquentes :

- **copie de la clé privée** dans GitHub : GitHub la refuse (`Key is invalid`). Si c'est arrivé, la clé est à considérer comme compromise : la **supprimer et en régénérer une** ;
- ligne publique **tronquée** à la copie (sélection partielle) ;
- `ssh-keygen` lancé avec `sudo` : la clé est créée dans `/root/.ssh/`, inaccessible.

---

## Partie 6 — Publier son dépôt sur GitHub

### Question 6.3

```text
$ git remote -v
origin	git@github.com:lea-martin/tp01-git.git (fetch)
origin	git@github.com:lea-martin/tp01-git.git (push)
$ git push -u origin main
To github.com:lea-martin/tp01-git.git
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```

2. **Oui**, GitHub affiche exactement les mêmes commits (mêmes hashs, mêmes messages) : `git push` envoie l'historique complet. `brouillon.txt` n'est **pas** sur GitHub : il est ignoré par `.gitignore`, il n'a jamais été commité, et `push` n'envoie que des commits.

Erreur fréquente : dépôt GitHub créé **avec un README** → le premier `push` est refusé (`fetch first`). Solution la plus simple pour des débutants : supprimer le dépôt GitHub et le recréer vide. (Alternative : `git pull --no-rebase --allow-unrelated-histories`, à éviter ici.)

### Question 6.4 a

```text
$ git status
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

Non, le dépôt local ne contient pas la modification, et **`git status` ne prévient pas** : il annonce même `up to date with 'origin/main'`. `git status` ne consulte **jamais le réseau** : il compare avec l'état de GitHub **tel qu'il était lors du dernier échange** (`push`, `pull` ou `fetch`). Le dépôt local ne sait pas que GitHub a changé.

### Question 6.4 b

```text
$ git pull
Updating 3f3dd2e..49d8b82
Fast-forward
 README.md | 1 +
 1 file changed, 1 insertion(+)
$ git log -1 --format='auteur : %an <%ae>%ncommitter : %cn <%ce>'
auteur : Léa Martin <lea.martin@exemple.fr>
committer : GitHub <noreply@github.com>
```

`git pull` a **téléchargé** le nouveau commit et **mis à jour** les fichiers (*fast-forward* : on a simplement avancé au bout de l'historique). L'auteur est **l'étudiant** (connecté sur le site) ; GitHub apparaît comme *committer* (visible avec `git log --format=fuller`, pas attendu des étudiants). C'est ce que contrôle `verifier.sh`.

### Question 6.5

```text
Répertoire de travail --( git add )--> Zone de préparation --( git commit )--> Dépôt local --( git push )--> GitHub
          ^                                                                                                    |
          +-------------------------------------( git pull / git clone )---------------------------------------+
```

---

## Partie 7 — Cloner

### Question 7.1

1. **Tout l'historique** : `git log --oneline` dans le clone montre les mêmes commits que l'original.
2. **Non** : `brouillon.txt` n'a jamais été commité (ignoré), il n'existe que dans le dossier d'origine.
3. **Non** : `git clone` crée le dépôt (`.git/`) et configure automatiquement le dépôt distant `origin`, visible avec `git remote -v`.

### Question 7.2

```text
$ git pull          # côté « lycée »
Updating c8b950e..02a584c
Fast-forward
 memo-git.md | 1 +
```

- `git pull` en **début** de séance : partir de la **dernière version**, qui peut avoir été modifiée ailleurs (maison, autre poste, coéquipier, site web). Sinon, on travaille sur une version ancienne et on s'expose à des **conflits**.
- `git push` en **fin** de séance : **sauvegarder** sur GitHub et rendre le travail disponible ailleurs. Un travail non poussé reste bloqué sur le poste (et disparaît si la session du poste est réinitialisée).

### Question 7.3

1. Résultat attendu : **25 / 25**.
2. Le dépôt a été cloné en **HTTPS** et il appartient à `ciel-ir-rascol` : `git commit` fonctionne (c'est local), mais `git push` demande un identifiant (`Username for 'https://github.com'`). Même en s'authentifiant, l'étudiant n'a **pas le droit d'écrire** dans le dépôt de quelqu'un d'autre (erreur 403). Pour contribuer, il faut un **fork** (copie sur son propre compte) : c'est la transition vers les TP suivants.

---

## Bonus 2 — Conflit

Déroulé de référence :

```text
$ git push
 ! [rejected]        main -> main (fetch first)
hint: Updates were rejected because the remote contains work that you do not
hint: have locally. [...] use 'git pull' before pushing again.

$ git pull
hint: You have divergent branches and need to specify how to reconcile them.
[...]
fatal: Need to specify how to reconcile divergent branches.

$ git config --global pull.rebase false
$ git pull
Auto-merging README.md
CONFLICT (content): Merge conflict in README.md
Automatic merge failed; fix conflicts and then commit the result.

$ cat README.md
<<<<<<< HEAD
# TP01 — Mes premiers pas avec Git
=======
# TP01 — Découverte de Git et GitHub
>>>>>>> 01142ef66ea123a10567f61d67f1fa858c9ca4df
```

- Entre `<<<<<<< HEAD` et `=======` : la version **locale** ; entre `=======` et `>>>>>>>` : la version **distante** (GitHub).
- Résolution : garder une version (ou combiner les deux), **supprimer les trois marqueurs**, puis `git add README.md`, `git commit` (message de fusion proposé automatiquement) et `git push`.

```text
$ git log --oneline --graph
*   a4f49f9 Merge branch 'main' of github.com:lea-martin/tp01-git
|\
| * 01142ef Update README.md
* | 61296eb Nouveau titre du README
|/
* ba71a65 Questions 7.1 à 7.3
```

Explication attendue : la **même ligne** a été modifiée **différemment** des deux côtés depuis le dernier point commun ; Git ne peut pas choisir à la place de l'humain.

Erreur fréquente : committer le fichier **avec les marqueurs** `<<<<<<<`. À vérifier dans le README sur GitHub.
