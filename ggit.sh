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
case $1 in
    c|commit)
        for gd in $(ls $gitdir) ; do
            echo "====> Dossier $gd :"
            cd $gitdir/$gd ; git commit -a
            echo ""
        done
        cd $HOME
        ;;
    p|pull)
        for gd in $(ls $gitdir) ; do
            echo "====> Dossier $gd :"
            cd $gitdir/$gd ; git pull
            echo ""
        done
        cd $HOME
        ;;
    *|push)
        for gd in $(ls $gitdir) ; do
            echo "====> Dossier $gd :"
            cd $gitdir/$gd
            git add * ; git commit -m "Mise à jour" ; git push
            echo ""
        done
        cd $HOME
        ;;
esac
