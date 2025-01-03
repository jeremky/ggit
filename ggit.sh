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

ggit_command() {
  for gd in $(ls $gitdir) ; do
    if [ -d $gitdir/$gd/.git ] ; then
      echo "====> Dossier $gd :"
        echo "cd $gitdir/$gd ; $command"
        echo ""
    fi
  done
  cd $HOME
}

## Commandes
echo ""
case $1 in
  c|commit)
    $command=$(git commit -a)
    ggit_command
    ;;
  p|pull)
    $command=$(git pull)
    ggit_command
    ;;
  *|push)
    $command=$(git add * ; git commit -m "Mise à jour" ; git push)
    ggit_command
    ;;
esac
