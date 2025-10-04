#!/bin/bash

# Messages en couleur
error()    { echo -e "\033[0;31m====> $*\033[0m" ;}
message()  { echo -e "\033[0;32m====> $*\033[0m" ;}
warning()  { echo -e "\033[0;33m====> $*\033[0m" ;}

# Droits
if [[ "$USER" = "root" ]]; then
  error "Ne pas lancer en tant que root !"
  exit 1
fi

gpush() { 
  echo
  warning "push de $(basename "$(realpath .)")"
  git add $(git ls-files --exclude-standard; git ls-files --modified; git ls-files --others --exclude-standard)
  git commit -m "Mise à jour" ; git push
}

gpull() {
  echo
  message "pull de $(basename "$(realpath .)")"
  git pull
}

# Exécution
gitdir="$(dirname "$0")/.."
case $1 in
  c|clone)
    git clone git@github.com:$(id -un)/$2
    ;;
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
echo
