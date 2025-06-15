#!/bin/bash

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
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
  case $1 in
    p|pull)
      shift
      echo ""
      for gd in $* ; do
        if [[ -d $gitdir/$gd/.git ]]; then
          echo -e "${GREEN}====> pull de $gd ${RESET}"
          cd $gitdir/$gd
          git pull
          echo ""
        fi
      done
      ;;
    *|push)
      echo ""
      for gd in $(ls -1 $gitdir) ; do
        if [[ -d $gitdir/$gd/.git ]]; then
          echo -e "${YELLOW}====> push de $gd ${RESET}"
          cd $gitdir/$gd
          git add *
          git add .*
          git commit -m "$message"
          git push
          echo ""
        fi
      done
  esac
  cd $HOME
fi
