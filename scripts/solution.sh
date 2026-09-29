#!/bin/bash
#
# solution.sh — Réalise le TP01 de bout en bout (parties 0 à 7 + bonus 2), en affichant
# chaque commande et sa sortie comme dans un terminal. Sert à valider le sujet et verifier.sh,
# et à produire les sorties de référence de CORRECTION.md.
#
# ⚠️ NE PAS lancer sur un poste réel : le script modifie ~/.gitconfig, crée ~/.ssh/id_ed25519
#    et ~/tp-git/. Il est prévu pour le banc de test (test-docker.sh). Pour forcer : SOLUTION_FORCER=1.
#
# Variables :
#   FAUX_GITHUB  dossier contenant les dépôts nus qui simulent GitHub (<FAUX_GITHUB>/<pseudo>/tp01-git.git),
#                l'URL git@github.com: étant réécrite vers ce dossier (url.<base>.insteadOf).
#                Sans elle, le script s'arrête après la partie 5 (les parties 6 et 7 demandent GitHub).
#   PSEUDO, NOM, EMAIL  identité de l'étudiant fictif
#
set -euo pipefail

PSEUDO="${PSEUDO:-lea-martin}"
NOM="${NOM:-Léa Martin}"
EMAIL="${EMAIL:-lea.martin@exemple.fr}"
FAUX_GITHUB="${FAUX_GITHUB:-}"
BASE="$HOME/tp-git"
DEPOT="$BASE/tp01-git"
URL="git@github.com:$PSEUDO/tp01-git.git"

if [ ! -f /.dockerenv ] && [ "${SOLUTION_FORCER:-0}" != 1 ]; then
    echo "Refus : ce script modifie la configuration Git et SSH de l'utilisateur." >&2
    echo "Lancez-le via test-docker.sh (ou forcez avec SOLUTION_FORCER=1)." >&2
    exit 1
fi

# --- Affichage -------------------------------------------------------------------
partie() { echo; echo "################################################################"; echo "# $*"; echo "################################################################"; }
etape()  { echo; echo "=== $* ==="; }
# run <commande...> : affiche la commande puis sa sortie ; une erreur n'arrête pas le script
run()    { echo "\$ $*"; "$@" 2>&1 || echo "[code de retour : $?]"; }
# runsh '<ligne shell>' : idem, pour les redirections et les pipes
runsh()  { echo "\$ $1"; bash -c "$1" 2>&1 || echo "[code de retour : $?]"; }
# ecrit <fichier> : écrit l'entrée standard dans le fichier (remplace l'édition avec nano)
ecrit()  { cat > "$1"; echo "(nano $1 : contenu écrit)"; }
ajoute() { cat >> "$1"; echo "(nano $1 : contenu ajouté)"; }

# Simule un commit fait avec l'interface web de GitHub : l'auteur est l'étudiant,
# le « committer » est GitHub (comme sur le vrai site).
commit_web() {
    local message="$1" script="$2" tmp
    tmp="$(mktemp -d)"
    git clone -q "$FAUX_GITHUB/$PSEUDO/tp01-git.git" "$tmp"
    (cd "$tmp" && bash -c "$script")
    GIT_COMMITTER_NAME=GitHub GIT_COMMITTER_EMAIL=noreply@github.com \
        git -C "$tmp" -c user.name="$NOM" -c user.email="$EMAIL" commit -qam "$message"
    git -C "$tmp" push -q origin main
    rm -rf "$tmp"
    echo "(sur GitHub, interface web : commit « $message »)"
}

# =================================================================================
partie "Partie 0 — Préparer son poste"
run git --version
mkdir -p "$BASE"; cd "$BASE"

# =================================================================================
partie "Partie 2 — Se présenter à Git"
run git config --global user.name "$NOM"
run git config --global user.email "$EMAIL"
run git config --global init.defaultBranch main
run git config --global core.editor nano
run git config --list --global
run cat "$HOME/.gitconfig"

# =================================================================================
partie "Partie 3 — Premier dépôt, premiers commits"
etape "3.1"
mkdir -p "$DEPOT"; cd "$DEPOT"
run git status

etape "3.2"
run git init
run ls -la
run git status

etape "3.3"
ecrit README.md <<EOF
# TP01 — Découverte de Git

Dépôt réalisé par $NOM, 1CIEL-IR.

Ce dépôt contient mon compte rendu du TP01.
EOF
run git status

etape "3.4"
run git add README.md
run git status

etape "3.5"
run git commit -m "Création du README"
run git status
run git log

etape "3.6"
ecrit COMPTE-RENDU.md <<'EOF'
# Compte rendu — TP01 Git

## Question 0

(version de Git relevée : voir CORRECTION.md)

## Questions 1 à 3.5

(réponses : voir CORRECTION.md)
EOF
run git add COMPTE-RENDU.md
run git commit -m "Ajout du compte rendu (questions 0 à 3.5)"

etape "3.7"
echo "Année scolaire 2026-2027." | ajoute README.md
run git status
run git diff
run git add README.md
run git commit -m "Ajout de l'année scolaire dans le README"

etape "3.8"
ecrit memo-git.md <<'EOF'
# Mon aide-mémoire Git

- `git init` : transforme le dossier courant en dépôt Git.
- `git status` : affiche l'état des fichiers (modifiés, préparés, non suivis).
- `git add fichier` : place le fichier dans la zone de préparation.
- `git commit -m "message"` : enregistre un commit avec les fichiers préparés.
EOF
printf '\n## Question 3.7\n\n(réponse)\n' | ajoute COMPTE-RENDU.md
run git status
run git add memo-git.md
run git commit -m "Création de l'aide-mémoire Git"
run git add COMPTE-RENDU.md
run git commit -m "Question 3.7"
run git log --oneline

# =================================================================================
partie "Partie 4 — Explorer l'historique et réparer ses erreurs"
etape "4.1"
HASH_ANNEE="$(git log --format=%h --grep="année scolaire")"
run git show "$HASH_ANNEE"

etape "4.2"
runsh 'echo "oups" > README.md'
run cat README.md
run git status
run git restore README.md
run cat README.md
run git status

etape "4.3"
runsh 'echo "fichier de test" > test.txt'
run git add test.txt
run git status
run git restore --staged test.txt
run git status

etape "4.4"
run touch brouillon.txt erreurs.log debug.log
run git status
ecrit .gitignore <<'EOF'
# Brouillons et fichiers de test
brouillon.txt
test.txt

# Journaux
*.log
EOF
run git status
printf '\n## Questions 3.8 à 4.4\n\n(réponses)\n' | ajoute COMPTE-RENDU.md
run git add .gitignore COMPTE-RENDU.md
run git commit -m "Ajout du .gitignore (questions 3.8 à 4.4)"

etape "4.5"
HASH_PREMIER="$(git rev-list --max-parents=0 --abbrev-commit HEAD)"
run git show "$HASH_PREMIER:README.md"
run git diff "$HASH_PREMIER" HEAD -- README.md
printf '\n## Question 4.5\n\n(réponse)\n' | ajoute COMPTE-RENDU.md
run git commit -am "Question 4.5"

# =================================================================================
partie "Partie 5 — Clé SSH"
etape "5.1"
run ls -l "$HOME/.ssh/"
etape "5.2"
if [ -f "$HOME/.ssh/id_ed25519" ]; then
    echo "(clé déjà présente : non régénérée)"
else
    # Dans le banc de test uniquement : pas de phrase de passe (-N ""). En TP, on en met une.
    run ssh-keygen -t ed25519 -C "$EMAIL" -N "" -f "$HOME/.ssh/id_ed25519"
fi
run ls -l "$HOME/.ssh/"
etape "5.3"
run cat "$HOME/.ssh/id_ed25519.pub"
echo "(dépôt de la clé publique dans GitHub : Settings → SSH and GPG keys → New SSH key)"
etape "5.4"
echo "(ssh -T git@github.com : non testable hors du vrai GitHub)"
printf '\n## Questions 5.2 et 5.4\n\n(réponses)\n' | ajoute COMPTE-RENDU.md
run git commit -am "Questions 5.2 et 5.4"

if [ -z "$FAUX_GITHUB" ]; then
    echo
    echo "FAUX_GITHUB non défini : arrêt avant la partie 6 (publication sur GitHub)."
    exit 0
fi

# =================================================================================
partie "Partie 6 — Publier son dépôt sur GitHub"
etape "6.2"
run git remote add origin "$URL"
run git remote -v
etape "6.3"
run git push -u origin main
run git log --oneline

etape "6.4"
commit_web "Update README.md" "echo \"Modifié depuis l'interface web de GitHub.\" >> README.md"
run git status
run cat README.md
run git pull
run cat README.md
run git log --oneline
run git log -1 --format='auteur : %an <%ae>%ncommitter : %cn <%ce>'

etape "6.5"
printf '\n## Questions 6.3 à 6.5\n\n(réponses)\n' | ajoute COMPTE-RENDU.md
run git status
run git add COMPTE-RENDU.md
run git commit -m "Questions 6.3 et 6.4"
run git push

# =================================================================================
partie "Partie 7 — Cloner : travailler depuis deux endroits"
etape "7.1"
cd "$BASE"
run git clone "$URL" tp01-git-maison
cd "$BASE/tp01-git-maison"
run git log --oneline
run ls -la
run git remote -v

etape "7.2"
echo '- `git log --oneline` : affiche l'"'"'historique, une ligne par commit.' | ajoute memo-git.md
run git add memo-git.md
run git commit -m "Ajout de git log dans l'aide-mémoire"
run git push
cd "$DEPOT"
run git pull
run cat memo-git.md

etape "7.3 (le clone HTTPS du dépôt du TP n'est pas rejoué : réseau)"
printf '\n## Questions 7.1 à 7.3\n\n(réponses)\n' | ajoute COMPTE-RENDU.md
run git commit -am "Questions 7.1 à 7.3"
run git push

# =================================================================================
partie "Bonus 2 — Provoquer (et résoudre) un conflit"
commit_web "Update README.md" "sed -i '1s/.*/# TP01 — Découverte de Git et GitHub/' README.md"
sed -i '1s/.*/# TP01 — Mes premiers pas avec Git/' README.md
echo "(nano README.md : titre modifié en local)"
run git add README.md
run git commit -m "Nouveau titre du README"
run git push
run git pull
run git config --global pull.rebase false
run git pull
run cat README.md
# Résolution : on garde la version locale
sed -i -e '/^<<<<<<< /d' -e '/^=======$/,/^>>>>>>> /d' README.md
echo "(nano README.md : marqueurs supprimés, version locale conservée)"
run cat README.md
run git add README.md
run git commit --no-edit
run git push
run git log --oneline --graph

partie "Fin : état du dépôt"
run git status
run git log --oneline
