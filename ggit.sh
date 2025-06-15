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

gpush() { git add * ; git add .* ; git commit -m "$message" ; git push ;}

# Exécution
cfg="$(dirname "$0")/ggit.cfg"
if [[ ! -f $cfg ]]; then
  echo -e "${RED}Fichier $cfg introuvable${RESET}"
  exit 0
else
  . $cfg
  case $1 in
    p|pull)
      echo ""
      if [[ -d .git ]]; then
        git pull
      else
        for gd in $(ls -1 $gitdir) ; do
          if [[ -d $gitdir/$gd/.git ]]; then
            echo -e "${GREEN}====> pull de $gd ${RESET}"
            cd $gitdir/$gd
            git pull
            echo ""
          fi
        done
      fi
      ;;
    *|push)
      echo ""
      if [[ -d .git ]]; then
        gpush
      else
        for gd in $(ls -1 $gitdir) ; do
          if [[ -d $gitdir/$gd/.git ]]; then
            echo -e "${YELLOW}====> push de $gd ${RESET}"
            cd $gitdir/$gd
            gpush
            echo ""
          fi
        done
      fi
  esac
  cd $HOME
fi
