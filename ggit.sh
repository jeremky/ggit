#!/bin/bash

## Variables
dir=$(dirname "$0")
cfg="$dir/$(basename -s .sh $0).cfg"

## Verification
if [ "$USER" = "root" ] ; then
  echo "Ne pas lancer en tant que root !"
  exit 0
fi
if [ -f $cfg ] ; then
  . $cfg
else
  echo "Fichier $cfg introuvable"
  exit 0
fi

## Commandes
echo ""
for gd in $(ls $gitdir) ; do
  if [ -d $gitdir/$gd/.git ] ; then
    echo "====> Dossier $gd :"
    cd $gitdir/$gd
    case $1 in
      p|pull)
        git pull
        ;;
      *|push)
        git add *
        git commit -m "Mise à jour"
        git push
        ;;
    esac
    echo ""
  fi
done
cd $HOME
exit 0
