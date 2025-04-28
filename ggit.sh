#!/bin/bash

if [[ "$USER" = "root" ]]; then
  echo "Ne pas lancer en tant que root !"
  exit 0
fi

cfg="$(dirname "$0")/ggit.cfg"
if [[ ! -f $cfg ]]; then
  echo "Fichier $cfg introuvable"
  exit 0
else
  . $cfg
  echo ""
  for gd in $(ls -1 $gitdir) ; do
    if [[ -d $gitdir/$gd/.git ]]; then
      echo "====> Dossier $gd :"
      cd $gitdir/$gd
      git add *
      git commit -m "Mise à jour"
      git push
      echo ""
    fi
  done
  cd $HOME
fi
