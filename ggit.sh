#!/bin/bash

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Droits
if [[ "$USER" = "root" ]]; then
  echo -e "${RED}Ne pas lancer en tant que root !${RESET}"
  exit 0
fi

gpush() { 
  echo ""
  echo -e "${YELLOW}====> push de $(basename "$(realpath .)")${RESET}"
  git add * ; git add .* ; git commit -m "$message" ; git push
}

gpull() {
  echo ""
  echo -e "${GREEN}====> pull de $(basename "$(realpath .)")${RESET}"
  git pull
}

# Exécution
cfg="$(dirname "$0")/ggit.cfg"
if [[ ! -f $cfg ]]; then
  echo -e "${RED}Fichier $cfg introuvable${RESET}"
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
