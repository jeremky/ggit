#!/bin/bash

# Colored messages
error() { echo -e "\033[0;36m──────────\033[0m\n\033[0;31m❯ $*\033[0m"; }
message() { echo -e "\033[0;36m──────────\033[0m\n\033[0;32m❯ $*\033[0m"; }
warning() { echo -e "\033[0;33m❯ $*\033[0m\n\033[0;36m──────────\033[0m"; }

# Config
cfg="$(dirname "$(realpath "$0")")/ggit.cfg"
if [[ ! -f "$cfg" ]]; then
  error "File $cfg not found"
  exit 1
fi

# Check dependencies
if ! command -v git &>/dev/null; then
  error "Git is not installed"
  exit 1
fi

# Functions
usage() {
  cat <<EOF
Usage: $(basename "$0") [command] [options]

Commands:
  (none) | push            Add, commit and push changes
  p | pull                 Pull each repository
  s | status               Show the status of each repository
  g | garbage              Clean up (git gc) each repository
  c | clone <repo...>      Clone one or more repositories
                           If $webclone is set in $cfg, also add it as a push remote
  h | help                 Show this help
EOF
}

gpush() {
  echo
  warning "Pushing $(basename "$(realpath .)")"
  if [[ -z $(git status --porcelain) ]]; then
    echo "Nothing to commit"
    return
  fi
  git add -A
  git commit -m "Update" && git push
}

gpull() {
  echo
  warning "Pulling $(basename "$(realpath .)")"
  git pull || error "Pull failed"
}

gstatus() {
  echo
  warning "Status of $(basename "$(realpath .)")"
  git status --short --branch || error "Corrupted git repository"
}

gclone() {
  local app=$1
  echo
  warning "Cloning $app from $webgit"
  git clone "git@$webgit:$user/$app" || return 1
  if [[ -n "$webclone" ]]; then
    (
      cd "$app" || return
      git remote set-url --add --push origin "git@$webgit:$user/$app.git"
      git remote set-url --add --push origin "git@$webclone:$user/$app.git"
    )
    message "Push mirror to $webclone added"
  fi
}

gclean() {
  repo="$(basename "$(realpath .)")"
  echo
  warning "Cleaning $repo"
  git gc --aggressive --prune=now
  message "$repo cleaned"
}

gitrun() {
  local fn=$1
  if [[ -d .git ]]; then
    "$fn"
  else
    if [[ -z "$gitdir" ]]; then
      error "gitdir variable not set in $cfg"
      exit 1
    fi
    for gd in "$gitdir"/*; do
      [[ -d "$gd/.git" ]] && (cd "$gd" && "$fn")
    done
  fi
}

# Execution
# shellcheck source=./ggit.cfg
. "$cfg"

case "$1" in
  c | clone)
    shift
    for app in "$@"; do
      gclone "$app"
    done
    ;;
  g | garbage)
    gitrun gclean
    ;;
  p | pull)
    gitrun gpull
    ;;
  s | status)
    gitrun gstatus
    ;;
  "" | push)
    gitrun gpush
    ;;
  h | help | -h | --help)
    usage
    ;;
  *)
    error "Unknown command: $1"
    usage
    exit 1
    ;;
esac
echo
