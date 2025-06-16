#!/bin/bash

# Messages colorisés
error()    { echo -e "\033[0;31m====> $*\033[0m" ;}
message()  { echo -e "\033[0;32m====> $*\033[0m" ;}
warning()  { echo -e "\033[0;33m====> $*\033[0m" ;}

# Droits
if [[ "$USER" = "root" ]]; then
  error "Ne pas lancer en tant que root !"
  exit 1
fi

gpush() { 
  echo ""
  warning "push de $(basename "$(realpath .)")"
  git add * ; git add .* ; git commit -m "$message" ; git push
}

gpull() {
  echo ""
  warning "pull de $(basename "$(realpath .)")"
  git pull
}

# Exécution
cfg="$(dirname "$0")/ggit.cfg"
if [[ ! -f $cfg ]]; then
  error "Fichier $cfg introuvable"
  exit 1
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
