#!/bin/bash

# Coleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

if [[ "$USER" = "root" ]]; then
  echo -e "${RED}Ne pas lancer en tant que root !${RESET}"
  exit 0
fi

dir=$(dirname "$0")
cfg="$dir/ggit.cfg"
if [[ ! -f $cfg ]]; then
  echo -e "${RED}Fichier $cfg introuvable${RESET}"
  exit 0
else
  . $cfg
  echo ""
  for gd in $(ls -1 $gitdir) ; do
    if [[ -d $gitdir/$gd/.git ]]; then
      GREEN='\033[0;32m'
      RESET='\033[0m'
      echo -e "${GREEN}====> $gd ${RESET}"
      cd $gitdir/$gd
      git add *
      git add .*
      git commit -m "$message"
      git push
      echo ""
    fi
  done
  cd $HOME
fi
