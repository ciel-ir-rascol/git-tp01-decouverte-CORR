#!/bin/bash
#
# test-docker.sh — Banc de test du TP01 dans un conteneur Ubuntu 24.04 (comme les postes) :
#   poste vierge -> verifier.sh -> solution.sh -> verifier.sh
#
# GitHub est simulé par des dépôts nus locaux : l'URL git@github.com:<pseudo>/<depot>.git
# est réécrite vers /srv/github/<pseudo>/<depot>.git (url.<base>.insteadOf, configuration système).
# Seul contrôle impossible à simuler : l'authentification SSH auprès de GitHub (24/25 attendu).
#
# Usage : ./test-docker.sh        (depuis n'importe où ; sorties dans solution.log)
#
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPOT_TP="$(cd "$SCRIPT_DIR/../../git-tp01-decouverte" && pwd)"
LOG="$SCRIPT_DIR/solution.log"

docker run --rm -i \
    -v "$SCRIPT_DIR:/corr:ro" -v "$DEPOT_TP:/tp:ro" \
    ubuntu:24.04 bash -s <<'EOF' 2>&1 | tee "$LOG"
set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq >/dev/null
apt-get install -y -qq git openssh-client locales >/dev/null 2>&1
sed -i 's/^# *fr_FR.UTF-8/fr_FR.UTF-8/' /etc/locale.gen && locale-gen >/dev/null
export LANG=fr_FR.UTF-8

# Faux GitHub
mkdir -p /srv/github/lea-martin
git init -q --bare --initial-branch=main /srv/github/lea-martin/tp01-git.git
git config --system url./srv/github/.insteadOf git@github.com:

echo ">>>>> verifier.sh sur un poste vierge"
/tp/scripts/verifier.sh || true

echo ">>>>> solution.sh"
FAUX_GITHUB=/srv/github bash /corr/solution.sh

echo ">>>>> verifier.sh après solution.sh"
/tp/scripts/verifier.sh | sed 's/\x1b\[[0-9;]*m//g'
EOF
echo
echo "Journal complet : $LOG"
