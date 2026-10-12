# Corrigé commenté — TP01 Découverte de Git et GitHub

Pour chaque question : la **réponse attendue**, un **exemple de sortie** du terminal et, quand c'est utile, une explication (💡 *Pour comprendre*) et les **erreurs fréquentes** (⚠️).

Les exemples sont ceux de Léa Martin, étudiante fictive (Git 2.43.0, Ubuntu 24.04). Vos hashs, dates, nom et e-mail seront différents.

---

## Sommaire

- [Messages de Git en anglais et en français](#messages-de-git-en-anglais-et-en-français)
- [Ce qui est évalué](#ce-qui-est-évalué)
- [Partie 0 — Préparer son poste](#partie-0--préparer-son-poste)
- [Partie 1 — Compte GitHub](#partie-1--compte-github)
- [Partie 2 — Se présenter à Git](#partie-2--se-présenter-à-git)
- [Partie 3 — Premier dépôt, premiers commits](#partie-3--premier-dépôt-premiers-commits)
- [Partie 4 — Explorer l'historique et réparer ses erreurs](#partie-4--explorer-lhistorique-et-réparer-ses-erreurs)
- [Partie 5 — Clé SSH](#partie-5--clé-ssh)
- [Partie 6 — Publier son dépôt sur GitHub](#partie-6--publier-son-dépôt-sur-github)
- [Partie 7 — Cloner](#partie-7--cloner)
- [Bonus 2 — Conflit](#bonus-2--conflit)
- [À retenir](#-à-retenir)

---

## Messages de Git en anglais et en français

Les exemples de ce corrigé sont en anglais. Si votre poste est en français, Git traduit ses messages : voici les correspondances des plus courants.

| Anglais | Français | Sens |
| --- | --- | --- |
| `fatal: not a git repository (or any of the parent directories): .git` | `fatal: ni ceci ni aucun de ses répertoires parents n'est un dépôt git : .git` | Vous n'êtes pas dans un dépôt |
| `On branch main` | `Sur la branche main` | Branche sur laquelle vous travaillez |
| `No commits yet` | `Aucun commit` | Dépôt tout neuf, historique vide |
| `Untracked files` | `Fichiers non suivis` | Fichiers que Git ne connaît pas encore |
| `Changes to be committed` | `Modifications qui seront validées` | Zone de préparation : partira dans le prochain commit |
| `Changes not staged for commit` | `Modifications qui ne seront pas validées` | Modifié, mais pas encore `git add` |
| `new file` / `modified` | `nouveau fichier` / `modifié` | Nature de la modification |
| `nothing to commit, working tree clean` | `rien à valider, la copie de travail est propre` | Tout est commité |
| `Your branch is up to date with 'origin/main'` | `Votre branche est à jour avec 'origin/main'` | Rien à envoyer ni à recevoir… **d'après le dernier échange** (voir 6.4 a) |

---

## Ce qui est évalué

Votre rendu est le dépôt `tp01-git` publié sur GitHub. Voici comment les points se répartissent :

| Partie | Ce qu'on attend de vous | Points |
| :---: | --- | :---: |
| 0 – 2 | Version de Git, URL du profil, configuration correcte, rôle de `--global` | 2 |
| 3 | Questions 3.1 à 3.8 : zones identifiées, `git log` commenté, hash (40 caractères hexadécimaux, 160 bits), deux commits séparés | 5 |
| 4 | `git show`, `restore`, `restore --staged`, `.gitignore`, lecture d'une ancienne version | 4 |
| 5 | Clé ed25519 créée, permissions expliquées, `ssh -T` réussi, différence publique / privée expliquée | 3 |
| 6 | Dépôt publié en SSH, commit web récupéré par `pull`, schéma de la chaîne complet | 3 |
| 7 | Clone, aller-retour maison / lycée, script de vérification au vert | 2 |
| — | Qualité des commits : nombre, messages clairs, un commit = une idée | 1 |
| | | **/20** |

Le script `verifier.sh` (question 7.3) contrôle la partie **technique** : si tout est au vert, vos manipulations sont correctes. Il ne lit pas vos **explications** : les « pourquoi » de `COMPTE-RENDU.md` sont corrigés à la main. Une sortie copiée sans phrase d'explication ne rapporte pas tous les points.

---

## Partie 0 — Préparer son poste

### Question 0

```text
$ git --version
git version 2.43.0
```

**Réponse :** Git **2.43.0**, la version fournie par Ubuntu 24.04 LTS.

> [!NOTE]
> **Dans la VM, chez soi** : Git n'y est pas installé. `git --version` répond que la commande est introuvable. Il faut d'abord `sudo apt update` puis `sudo apt install git` : la version obtenue est la même, **2.43.0**, puisque la VM est elle aussi en Ubuntu 24.04 LTS.

---

## Partie 1 — Compte GitHub

### Question 1

**Réponse :** une URL de la forme `https://github.com/lea-martin`.

Vérifiez que vous avez bien :

- un **pseudo** sobre et durable : pas d'année de naissance, pas de référence au lycée. Un recruteur le lira dans trois ans ;
- un **e-mail personnel** : l'adresse du lycée disparaîtra à la fin de vos études, et avec elle la possibilité de récupérer votre compte ;
- noté vos **codes de récupération** (*recovery codes*) quand GitHub activera la double authentification (2FA). Sans eux, un téléphone perdu = un compte perdu : le support de GitHub ne rétablit pas l'accès.

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

1. Sortie ci-dessus. Git affiche les noms de réglages en minuscules (`init.defaultbranch`) : c'est normal, il ne fait pas la différence.
2. `--global` signifie que le réglage s'applique à **tous vos dépôts** sur ce poste. Il est enregistré dans le fichier **`~/.gitconfig`** de votre dossier personnel :

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

> 💡 **Pour comprendre**
>
> Sans `--global`, le réglage ne vaudrait que pour le **dépôt courant** (il serait écrit dans `.git/config`). C'est utile, par exemple, pour utiliser une adresse e-mail différente dans un dépôt particulier.
>
> Le nom et l'e-mail sont **recopiés dans chaque commit** : c'est grâce à l'e-mail que GitHub relie vos commits à votre profil. Si vous vous trompez d'adresse, vos commits apparaîtront sur GitHub sans votre avatar.

---

## Partie 3 — Premier dépôt, premiers commits

### Question 3.1

```text
$ git status
fatal: not a git repository (or any of the parent directories): .git
```

**Réponse :** Git répond que le dossier **n'est pas un dépôt**.

> 💡 **Pour comprendre**
>
> Un dossier ne devient un dépôt que s'il contient un dossier `.git/`. À chaque commande, Git le cherche dans le dossier courant, puis dans le dossier parent, et ainsi de suite jusqu'à la racine. Ici, il n'en trouve aucun.
>
> C'est **le message d'erreur le plus fréquent** quand on débute : il veut presque toujours dire « vous n'êtes pas dans le bon dossier ». Réflexe : `pwd`.

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

1. `git init` a créé le dossier **`.git/`**. Son nom commence par un point : sous Linux, c'est un **fichier caché**, que `ls` n'affiche qu'avec l'option `-a`.
2. `git status` répond maintenant : on est sur la branche `main`, il n'y a **encore aucun commit**, et rien à valider.

> 💡 **Pour comprendre**
>
> `.git/` **est** le dépôt : il contient tout l'historique. Les autres fichiers du dossier (le *répertoire de travail*) ne sont qu'une copie de travail. Supprimer `.git/`, c'est perdre tout l'historique.

### Question 3.3

```text
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	README.md
```

**Réponse :** `README.md` est dans la section **fichiers non suivis** (*Untracked files*, en rouge). Il se trouve uniquement dans le **répertoire de travail** : Git voit qu'il existe, mais ne l'a jamais enregistré.

### Question 3.4

```text
Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
	new file:   README.md
```

**Réponse :** le fichier est passé dans la section **à valider** (*Changes to be committed*, en vert), avec la mention *new file*. Il se trouve maintenant dans la **zone de préparation**.

> 💡 **Pour comprendre**
>
> La zone de préparation est la **liste de ce qui partira dans le prochain commit**. `git add` ne crée pas de commit : il prépare. Cela permet de choisir précisément quels fichiers on enregistre ensemble (voir 3.8).

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
2. - **Hash** : `8fd681287ceb283e8153ab57436093354b6227b9` (le vôtre est différent) ;
   - **auteur** : `Léa Martin <lea.martin@exemple.fr>` ;
   - **date** : `Tue Sep 29 09:03:21 2026` ;
   - **message** : `Création du README`.
3. Le hash comporte **40 caractères**, écrits en **hexadécimal** (base 16 : chiffres 0 à 9 et lettres a à f). Un chiffre hexadécimal code 4 bits, donc 40 × 4 = **160 bits**.

> 💡 **Pour comprendre**
>
> Le hash est l'**identifiant unique** du commit. Il est calculé à partir du contenu, de l'auteur, de la date, du message et du commit précédent : deux commits différents n'ont jamais le même hash. C'est pour cela que le vôtre ne ressemble pas à celui de Léa.
>
> On n'a presque jamais besoin des 40 caractères : les **7 premiers** (`8fd6812`) suffisent à désigner un commit, c'est ce qu'affiche `git log --oneline`.
>
> `root-commit` indique le tout premier commit du dépôt : il n'a pas de parent.
>
> Lien avec le TD02 de maths (changements de base) : 16 = 2⁴, d'où les 4 bits par chiffre.

### 3.6 — Le compte rendu

Pas de question, mais votre `COMPTE-RENDU.md` doit ressembler à ceci :

````markdown
# Compte rendu — TP01 Git

## Question 0

La version de Git installée est 2.43.0.

```text
$ git --version
git version 2.43.0
```

## Question 1

...
````

- un titre `## Question …` par question, pour qu'on s'y retrouve ;
- les sorties du terminal **dans des blocs de code** (trois accents graves), sinon GitHub les affiche mal ;
- une phrase de réponse **en plus** de la sortie copiée.

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
2. `git diff` montre **ce qui a changé** dans le fichier depuis la dernière version connue de Git. Le `+` marque une **ligne ajoutée** ; un `-` marquerait une ligne supprimée. Les lignes sans signe sont là pour le contexte.

> 💡 **Pour comprendre**
>
> Comparez avec la question 3.3 : un fichier **non suivi** est un fichier que Git n'a jamais vu ; un fichier **modifié** est un fichier déjà commité, dont le contenu a changé depuis. Dans les deux cas, il faut `git add` pour le préparer.
>
> Prenez l'habitude de lancer `git diff` **avant** chaque `git add` : vous relisez ce que vous allez enregistrer.

### Question 3.8

```text
$ git log --oneline
43cb3a0 Question 3.7
f8a734e Création de l'aide-mémoire Git
874f977 Ajout de l'année scolaire dans le README
7f6d958 Ajout du compte rendu (questions 0 à 3.5)
8fd6812 Création du README
```

1. Sortie ci-dessus : le commit le plus **récent** est **en haut**.
2. **Un commit = une idée.** Avec deux commits séparés :
   - chaque message décrit **une seule** modification : l'historique se lit comme un journal clair ;
   - on retrouve facilement **quand** et **pourquoi** une modification a été faite ;
   - on peut **annuler l'une sans l'autre**.

   Un `git add .` suivi d'un seul commit mélange tout, et risque en plus d'embarquer des fichiers qu'on ne voulait pas enregistrer (brouillons, fichiers de test…).

> ⚠️ **Erreurs fréquentes**
>
> - Messages vides de sens : `"modif"`, `"update"`, `"aaa"`. Un bon message dit **ce que fait** le commit : `"Ajout du .gitignore"`, `"Questions 4.1 et 4.2"`.
> - Un seul gros commit en fin de séance : on perd tout l'intérêt de l'historique, et c'est évalué.

---

## Partie 4 — Explorer l'historique et réparer ses erreurs

### Question 4.1

**Réponse :** `git show <hash>` affiche :

- les **informations** du commit : hash complet, auteur, date, message (comme `git log`) ;
- **les modifications** qu'il apporte, au même format que `git diff` (ici, la ligne `+Année scolaire 2026-2027.`).

### Question 4.2

```text
$ git restore README.md
$ cat README.md
# TP01 — Découverte de Git
...
Année scolaire 2026-2027.
```

**Réponse :** `git restore` a **remplacé le fichier du répertoire de travail par la dernière version enregistrée** par Git. La modification « oups » est **définitivement perdue**.

**Non**, on n'aurait pas pu récupérer un fichier **jamais commité** (ni même ajouté avec `git add`) : Git ne l'a jamais enregistré, il n'en a aucune copie.

> 💡 **Pour comprendre**
>
> Git ne protège que ce que vous lui avez confié. **Committez souvent** : chaque commit est un point de sauvegarde vers lequel vous pouvez revenir.
>
> Attention, `git restore` est l'une des rares commandes Git qui **détruisent** du travail : les modifications non commitées du fichier sont écrasées, sans corbeille.

### Question 4.3

```text
$ git restore --staged test.txt
$ git status
Untracked files:
	test.txt
```

**Réponse :** `test.txt` est revenu dans le **répertoire de travail** (non suivi). Il n'a **pas été supprimé** du disque.

> 💡 **Pour comprendre**
>
> Ne confondez pas les deux formes de `git restore` :
>
> | Commande | Effet | Dangereux ? |
> | --- | --- | :---: |
> | `git restore --staged fichier` | Retire le fichier de la zone de préparation. Le fichier ne bouge pas. | Non |
> | `git restore fichier` | Écrase le fichier par sa dernière version enregistrée. | **Oui** |
>
> C'est d'ailleurs ce que `git status` vous suggère dans ses messages entre parenthèses : lisez-les.

### Question 4.4

```text
$ git status          # après création du .gitignore
Untracked files:
	.gitignore
```

1. `brouillon.txt`, `test.txt`, `erreurs.log` et `debug.log` ont disparu. `*.log` est un **motif** : `*` remplace n'importe quelle suite de caractères, donc **tous les fichiers qui se terminent par `.log`** sont ignorés.
2. Le fichier **`.gitignore`** lui-même apparaît. **Oui**, il faut le committer : il fait partie du projet, et toute personne qui clonera le dépôt (ou vous-même, sur un autre poste) profitera des mêmes règles.

> 💡 **Pour comprendre**
>
> `.gitignore` ne concerne que les fichiers **non suivis**. Un fichier déjà commité reste suivi, même si on l'ajoute ensuite au `.gitignore`. D'où l'intérêt de créer le `.gitignore` **tôt** dans un projet, avant d'avoir commité un fichier par erreur.
>
> En administration système, c'est vital : un mot de passe ou une clé commité par erreur et poussé sur GitHub est **public**, et reste dans l'historique même si on supprime le fichier ensuite.

### Question 4.5

```text
$ git show 8fd6812:README.md
# TP01 — Découverte de Git

Dépôt réalisé par Léa Martin, 1CIEL-IR.

Ce dépôt contient mon compte rendu du TP01.
$ git diff 8fd6812 HEAD -- README.md
+Année scolaire 2026-2027.
```

**Réponse :** lors du premier commit, `README.md` contenait le titre, le nom de l'auteur et la phrase de présentation. Depuis, la ligne « Année scolaire 2026-2027. » a été ajoutée. (Si vous aviez déjà fait la partie 6, vous voyez aussi la ligne ajoutée depuis GitHub.)

> 💡 **Pour comprendre**
>
> - `HEAD` désigne le **commit sur lequel vous êtes**, c'est-à-dire le plus récent de votre branche.
> - `git show hash:fichier` **affiche** une ancienne version sans rien modifier : c'est un voyage dans le temps en lecture seule. Vos fichiers actuels ne bougent pas.
> - `-- README.md` limite la comparaison à ce fichier.

---

## Partie 5 — Clé SSH

### Question 5.2

```text
$ ls -l ~/.ssh/
-rw------- 1 etudiant etudiant 411 sept. 29 09:03 id_ed25519
-rw-r--r-- 1 etudiant etudiant 103 sept. 29 09:03 id_ed25519.pub
```

1. Deux fichiers ont été créés : `id_ed25519` est la clé **privée**, `id_ed25519.pub` (*pub* pour *public*) est la clé **publique**. Un troisième fichier, `known_hosts`, apparaîtra après la première connexion à GitHub : il mémorise les serveurs déjà rencontrés.
2. - `id_ed25519` : `rw-------` (**600**) ;
   - `id_ed25519.pub` : `rw-r--r--` (**644**).

   La clé privée est un **secret** : seul son propriétaire doit pouvoir la lire. SSH **refuse** même d'utiliser une clé privée lisible par d'autres (message `UNPROTECTED PRIVATE KEY FILE`). La clé publique peut être lue par tout le monde : ce n'est pas un problème, elle est faite pour être partagée.

### Question 5.4

```text
$ ssh -T git@github.com
Hi lea-martin! You've successfully authenticated, but GitHub does not provide shell access.
```

1. Sortie ci-dessus : GitHub vous reconnaît et affiche **votre pseudo**.
2. La clé publique sert seulement à **vérifier** une réponse ; elle ne permet pas d'en **produire** une. La donner à GitHub ne permet donc à personne de se faire passer pour vous. La clé privée, elle, permet de **répondre au défi** envoyé par GitHub : quiconque la possède peut se faire passer pour vous et modifier tous vos dépôts.

> 💡 **Pour comprendre : l'analogie du cadenas**
>
> La clé publique est un **cadenas ouvert** que vous distribuez : n'importe qui peut fermer une boîte avec, mais seule **votre clé privée** l'ouvre. GitHub vous envoie une boîte fermée avec votre cadenas ; si vous l'ouvrez, il sait que c'est vous. Votre clé privée, elle, n'a jamais voyagé.

> ⚠️ **Erreurs fréquentes**
>
> - **Copier la clé privée** dans GitHub (sortie qui commence par `-----BEGIN OPENSSH PRIVATE KEY-----`). GitHub la refuse (`Key is invalid`), mais elle a été exposée : il faut la **supprimer et en générer une nouvelle**.
> - Ligne publique **coupée** à la copie : sélectionnez toute la ligne, de `ssh-ed25519` jusqu'à l'adresse e-mail.
> - `ssh-keygen` lancé avec `sudo` : la clé est créée dans le dossier de `root`, et votre utilisateur ne peut pas s'en servir. On ne lance **jamais** `ssh-keygen` ni `git` avec `sudo`.

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

1. Sorties ci-dessus. L'URL commence par `git@github.com:` : le dépôt est bien relié en **SSH**.
2. **Oui**, GitHub affiche exactement le même historique : mêmes hashs, mêmes messages, même ordre. `git push` envoie **tous les commits**, pas seulement les fichiers.

   **Non**, `brouillon.txt` n'est pas sur GitHub : il est ignoré par `.gitignore`, il n'a donc **jamais été commité**, et `git push` n'envoie que des commits.

> ⚠️ **Erreur fréquente : dépôt GitHub créé avec un README**
>
> Si vous avez coché *Add a README file* à la création, le dépôt GitHub contient déjà un commit que votre dépôt local n'a pas, et le premier `push` est refusé (`fetch first`). Le plus simple : **supprimer le dépôt sur GitHub** (*Settings → Danger Zone → Delete this repository*) et le recréer **vide**.

### Question 6.4 a

```text
$ git status
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

**Réponse :** **non**, le dépôt local ne contient pas la modification faite sur GitHub. Et **`git status` ne prévient pas** : il annonce même que la branche est à jour (*up to date*).

En effet, `git status` **ne consulte jamais le réseau**. Il compare votre dépôt avec l'état de GitHub **tel qu'il était lors du dernier échange** (`push` ou `pull`). Depuis, GitHub a changé, mais votre dépôt local n'en sait rien.

> 💡 **Pour comprendre**
>
> « *up to date with 'origin/main'* » veut dire « à jour par rapport à **ce que je sais** de GitHub », pas « à jour par rapport à GitHub en ce moment ». C'est la raison pour laquelle on fait **toujours un `git pull` avant de se mettre au travail** (question 7.2).

### Question 6.4 b

```text
$ git pull
Updating 3f3dd2e..49d8b82
Fast-forward
 README.md | 1 +
 1 file changed, 1 insertion(+)
```

**Réponse :** `git pull` a **téléchargé** le commit fait sur GitHub et **mis à jour** les fichiers : `README.md` contient maintenant la ligne ajoutée sur le site. *Fast-forward* signifie que Git a simplement avancé jusqu'au nouveau commit, sans rien avoir à fusionner.

L'auteur du dernier commit, c'est **vous** : vous étiez connecté sur GitHub quand vous avez fait la modification, GitHub l'a donc enregistrée à votre nom.

> 💡 **Pour aller plus loin**
>
> Avec `git log --format=fuller`, on voit qu'un commit a deux personnes : l'**auteur** (qui a écrit la modification : vous) et le ***committer*** (qui l'a enregistrée : ici `GitHub`).

### Question 6.5

```text
Répertoire de travail --( git add )--> Zone de préparation --( git commit )--> Dépôt local --( git push )--> GitHub
          ^                                                                                                    |
          +-------------------------------------( git pull / git clone )---------------------------------------+
```

> 💡 **Pour comprendre**
>
> Ce schéma résume tout le TP. Les trois premières zones sont **sur votre poste** : `add` et `commit` fonctionnent sans réseau. Seuls `push`, `pull` et `clone` communiquent avec GitHub.

---

## Partie 7 — Cloner

### Question 7.1

1. Le clone contient **tout l'historique** : `git log --oneline` y affiche les mêmes commits que dans le dépôt d'origine.
2. **Non**, `brouillon.txt` n'est pas dans le clone : il n'a jamais été commité (il est ignoré), il n'existe donc que dans le dossier d'origine.
3. **Non**, ni `git init` ni `git remote add` : `git clone` crée le dépôt (`.git/`) **et** configure automatiquement le dépôt distant `origin`, comme le montre `git remote -v`.

> 💡 **Pour comprendre**
>
> Un clone n'est pas une simple copie des fichiers : c'est un **dépôt complet**, avec tout l'historique. Si GitHub disparaissait, chaque clone permettrait de tout reconstruire.

### Question 7.2

```text
$ git pull          # côté « lycée »
Updating c8b950e..02a584c
Fast-forward
 memo-git.md | 1 +
```

- `git pull` **en début de séance** : on part de la **dernière version**, qui a pu être modifiée ailleurs (à la maison, sur un autre poste, par un coéquipier, sur le site de GitHub). Sinon, on travaille sur une version ancienne, et on s'expose à des **conflits** au moment du `push` (voir le bonus 2).
- `git push` **en fin de séance** : on **sauvegarde** son travail sur GitHub et on le rend disponible ailleurs. Un travail non poussé reste bloqué sur le poste… et disparaît si le poste est réinitialisé.

### Question 7.3

1. Résultat attendu : **25 / 25**, tout au vert.
2. `git commit` **fonctionne** (c'est une opération locale), mais `git push` **échoue** : Git demande un identifiant (`Username for 'https://github.com'`).

   Deux raisons :
   - le dépôt a été cloné en **HTTPS** : Git n'utilise pas votre clé SSH et demande un identifiant ;
   - surtout, ce dépôt appartient à `ciel-ir-rascol`, pas à vous : même identifié, vous n'avez **pas le droit d'y écrire** (erreur 403).

   Pour contribuer au dépôt de quelqu'un d'autre, on en fait d'abord une copie sur son propre compte : un ***fork***. C'est ce que vous ferez dans les prochains TP.

---

## Bonus 2 — Conflit

Voici le déroulé complet, étape par étape :

```text
$ git push
 ! [rejected]        main -> main (fetch first)
hint: Updates were rejected because the remote contains work that you do not
hint: have locally. [...] use 'git pull' before pushing again.
```

GitHub refuse : il contient un commit (celui fait sur le site) que vous n'avez pas.

```text
$ git pull
hint: You have divergent branches and need to specify how to reconcile them.
[...]
fatal: Need to specify how to reconcile divergent branches.

$ git config --global pull.rebase false
$ git pull
Auto-merging README.md
CONFLICT (content): Merge conflict in README.md
Automatic merge failed; fix conflicts and then commit the result.
```

Git essaie de fusionner les deux historiques, mais la même ligne a été modifiée des deux côtés : il s'arrête et vous demande de choisir.

```text
$ cat README.md
<<<<<<< HEAD
# TP01 — Mes premiers pas avec Git
=======
# TP01 — Découverte de Git et GitHub
>>>>>>> 01142ef66ea123a10567f61d67f1fa858c9ca4df
```

- Entre `<<<<<<< HEAD` et `=======` : **votre version locale** ;
- entre `=======` et `>>>>>>>` : **la version de GitHub**.

**Résolution :**

1. Ouvrir `README.md` avec `nano`, garder une des deux versions (ou combiner les deux) et **supprimer les trois lignes de marqueurs** ;
2. `git add README.md` : on indique à Git que le conflit est résolu ;
3. `git commit` : Git propose un message de fusion tout prêt (`Merge branch 'main' of …`), il suffit d'enregistrer et de quitter `nano` ;
4. `git push`.

```text
$ git log --oneline --graph
*   a4f49f9 Merge branch 'main' of github.com:lea-martin/tp01-git
|\
| * 01142ef Update README.md
* | 61296eb Nouveau titre du README
|/
* ba71a65 Questions 7.1 à 7.3
```

Le graphe montre bien les deux modifications faites **en parallèle** (une sur GitHub, une en local) à partir du même commit, puis réunies par le **commit de fusion**.

**Explication attendue :** la **même ligne** a été modifiée **différemment** des deux côtés depuis le dernier point commun. Git ne peut pas deviner laquelle garder : c'est à vous de décider.

> ⚠️ **Erreur fréquente**
>
> Committer le fichier **avec les marqueurs** `<<<<<<<`, `=======`, `>>>>>>>` encore dedans. Vérifiez toujours avec `cat` (ou sur GitHub) avant de pousser.

> 💡 **Pour comprendre**
>
> Un conflit n'est **pas une erreur** : c'est Git qui refuse de choisir à votre place. Le meilleur moyen de les éviter reste `git pull` en début de séance et `git push` en fin de séance.

---

## 📌 À retenir

### Les commandes du TP

| Commande | Ce qu'elle fait |
| --- | --- |
| `git config --global user.name "…"` | Indique votre nom à Git (une fois par poste) |
| `git init` | Transforme le dossier courant en dépôt (crée `.git/`) |
| `git status` | Affiche l'état des fichiers : **à lancer tout le temps** |
| `git add fichier` | Place le fichier dans la zone de préparation |
| `git commit -m "message"` | Enregistre un commit avec ce qui est préparé |
| `git log` / `git log --oneline` | Affiche l'historique |
| `git diff` | Montre les modifications pas encore préparées |
| `git show hash` | Affiche un commit et ses modifications |
| `git show hash:fichier` | Affiche un fichier tel qu'il était dans ce commit |
| `git restore fichier` | ⚠️ Écrase le fichier par sa dernière version enregistrée |
| `git restore --staged fichier` | Retire le fichier de la zone de préparation |
| `ssh-keygen -t ed25519 -C "e-mail"` | Crée une paire de clés SSH |
| `ssh -T git@github.com` | Teste la connexion SSH à GitHub |
| `git remote add origin URL` | Relie le dépôt local à un dépôt distant |
| `git push` / `git push -u origin main` | Envoie les commits vers GitHub |
| `git pull` | Récupère les commits de GitHub |
| `git clone URL` | Copie un dépôt complet (historique compris) |

### Les idées clés

1. **Trois zones locales** : répertoire de travail → (`add`) → zone de préparation → (`commit`) → dépôt. Puis GitHub avec `push` / `pull`.
2. **`git status` est votre boussole** : lisez son message en entier, il dit presque toujours quoi faire.
3. **Un commit = une idée**, avec un message qui dit ce qu'il fait.
4. **Git ne protège que ce qui est commité** : committez souvent.
5. **`git status` ne consulte pas GitHub** : `git pull` en début de séance, `git push` en fin de séance.
6. **La clé privée ne quitte jamais votre poste.** Seule la `.pub` va sur GitHub.
7. **On ne committe jamais un secret** (mot de passe, clé) : `.gitignore` est là pour ça.
