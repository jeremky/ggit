#!/bin/bash

cecho() {
  local RESET='\033[0m'
  case $1 in
    m|message) color='\033[0;32m' ;;
    w|warning) color='\033[0;33m' ;;
    e|error)   color='\033[0;31m' ;;
  esac
  shift
  echo -e "${color}$*${RESET}"
}

# Droits
if [[ "$USER" = "root" ]]; then
  cecho e "Ne pas lancer en tant que root !"
  exit 0
fi

gpush() { 
  echo ""
  cecho w "====> push de $(basename "$(realpath .)")"
  git add * ; git add .* ; git commit -m "$message" ; git push
}

gpull() {
  echo ""
  cecho m "====> pull de $(basename "$(realpath .)")"
  git pull
}

# Exécution
cfg="$(dirname "$0")/ggit.cfg"
if [[ ! -f $cfg ]]; then
  cecho e "Fichier $cfg introuvable"
  exit 0
else
  . $cfg
  case $1 in
    p|pull)
      if [[ -d .git ]]; then
        gpull
      else
        for gd in $(ls -1 $gitdir) ; do
          if [[ -d $gitdir/$gd/.git ]]; then
            cd $gitdir/$gd
            gpull
          fi
        done
      fi
      ;;
    *|push)
      if [[ -d .git ]]; then
        gpush
      else
        for gd in $(ls -1 $gitdir) ; do
          if [[ -d $gitdir/$gd/.git ]]; then
            cd $gitdir/$gd
            gpush
          fi
        done
      fi
  esac
  echo ""
  cd $HOME
fi
