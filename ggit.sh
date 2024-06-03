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
if [ "$server" != "$(hostname)" ] ; then
    echo "ggit ne peut être lancé sur sur $server"
    exit 0
fi

## Commandes
case $1 in
    c|commit)
        for gd in $gitdir ; do
            echo "====> Dossier $gd :"
            cd $gd ; git commit -a ; cd $HOME
            echo ""
        done
        ;;
    p|pull)
        for gd in $gitdir ; do
            echo "====> Dossier $gd :"
            cd $gd ; git pull ; cd $HOME
            echo ""
        done
        ;;
    *|push)
        for gd in $gitdir ; do
            echo "====> Dossier $gd :"
            cd $gd
            git add * ; git commit -m "Mise à jour" ; git push
            cd $HOME
            echo ""
        done
        ;;
esac
