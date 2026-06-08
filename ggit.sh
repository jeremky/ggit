#!/bin/bash

# Messages en couleur
error() { echo -e "\033[0;31m====> $*\033[0m"; }
message() { echo -e "\033[0;32m====> $*\033[0m"; }
warning() { echo -e "\033[0;33m====> $*\033[0m"; }

# Config
cfg="$(dirname "$(realpath "$0")")/ggit.cfg"
if [[ ! -f "$cfg" ]]; then
  error "Fichier $cfg introuvable"
  exit 1
fi

# Fonctions
gpush() {
  echo
  warning "push de $(basename "$(realpath .)")"
  git add -A
  git commit -m "Update" && git push
}

gpull() {
  echo
  message "pull de $(basename "$(realpath .)")"
  git pull
}

gclone() {
  echo
  message "Clone de $app sur $webgit..."
  git clone git@$webgit:$user/$app || return 1
  if [[ -n $webclone ]]; then
    (
      cd $app || return
      git remote set-url --add --push origin ssh://git@$webgit/$user/$app.git
      git remote set-url --add --push origin ssh://git@$webclone/$user/$app.git
    )
  fi
}

gclean() {
  echo
  message "clean de $(basename "$(realpath .)")"
  git gc --aggressive --prune=now
}

gitrun() {
  local fn=$1
  if [[ -d .git ]]; then
    $fn
  else
    for gd in "$gitdir"/*; do
      [[ -d "$gd/.git" ]] && (cd "$gd" && $fn)
    done
  fi
}

# Exécution
# shellcheck source=./ggit.cfg
. "$cfg"
case $1 in
  c | clone)
    shift
    for app in "$@"; do
      gclone
    done
    ;;
  g | garbage)
    gitrun gclean
    ;;
  p | pull)
    gitrun gpull
    ;;
  *)
    gitrun gpush
    ;;
esac
echo
