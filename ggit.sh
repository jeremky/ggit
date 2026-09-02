#!/bin/bash

# Messages en couleur
error() { echo -e "\033[0;36m──────────\033[0m\n\033[0;31m❱ $*\033[0m"; }
message() { echo -e "\033[0;36m──────────\033[0m\n\033[0;32m❱ $*\033[0m"; }
warning() { echo -e "\033[0;33m❱ $*\033[0m\n\033[0;36m──────────\033[0m"; }

# Config
cfg="$(dirname "$(realpath "$0")")/ggit.cfg"
if [[ ! -f "$cfg" ]]; then
  error "Fichier $cfg introuvable"
  exit 1
fi

# Vérification des dépendances
if ! command -v git &>/dev/null; then
  error "Git n'est pas installé"
  exit 1
fi

# Fonctions
usage() {
  cat <<EOF
Usage: $(basename "$0") [commande] [options]

Commandes :
  (aucune) | push          Ajoute, commit et pousse les modifications
  p | pull                 Pull sur chaque dépôt
  s | status               Affiche le statut de chaque dépôt
  g | garbage              Nettoie (git gc) chaque dépôt
  c | clone [-m|--mirror] <repo...>
                            Clone un ou plusieurs dépôts
                            -m, --mirror : ajoute aussi $webclone comme remote de push
  h | help                 Affiche cette aide
EOF
}

gpush() {
  echo
  warning "push de $(basename "$(realpath .)")"
  if [[ -z $(git status --porcelain) ]]; then
    echo "Rien à commit"
    return
  fi
  git add -A
  git commit -m "Mise à jour" && git push
}

gpull() {
  echo
  warning "pull de $(basename "$(realpath .)")"
  git pull || error "Erreur de pull"
}

gstatus() {
  echo
  warning "status de $(basename "$(realpath .)")"
  git status --short --branch || error "Base git corrompue"
}

gclone() {
  local app=$1
  local mirror=$2
  echo
  warning "Clone de $app sur $webgit..."
  git clone "git@$webgit:$user/$app" || return 1
  if [[ "$mirror" == 1 ]]; then
    if [[ -z "$webclone" ]]; then
      error "Variable webclone non définie dans $cfg"
      return 1
    fi
    (
      cd "$app" || return
      git remote set-url --add --push origin "git@$webgit:$user/$app.git"
      git remote set-url --add --push origin "git@$webclone:$user/$app.git"
    )
    message "Mirroir push vers $webclone ajouté"
  fi
}

gclean() {
  repo="$(basename "$(realpath .)")"
  echo
  warning "clean de $repo"
  git gc --aggressive --prune=now
  message "clean de $repo effectué"
}

gitrun() {
  local fn=$1
  if [[ -d .git ]]; then
    "$fn"
  else
    if [[ -z "$gitdir" ]]; then
      error "Variable gitdir non définie dans $cfg"
      exit 1
    fi
    for gd in "$gitdir"/*; do
      [[ -d "$gd/.git" ]] && (cd "$gd" && "$fn")
    done
  fi
}

# Exécution
# shellcheck source=./ggit.cfg
. "$cfg"

case "$1" in
  c | clone)
    shift
    mirror=0
    if [[ "$1" == "-m" || "$1" == "--mirror" ]]; then
      mirror=1
      shift
    fi
    for app in "$@"; do
      gclone "$app" "$mirror"
    done
    ;;
  g | garbage)
    gitrun gclean
    ;;
  p | pull)
    gitrun gpull
    ;;
  s | status)
    gitrun gstatus
    ;;
  "" | push)
    gitrun gpush
    ;;
  h | help | -h | --help)
    usage
    ;;
  *)
    error "Commande inconnue : $1"
    usage
    exit 1
    ;;
esac
echo
