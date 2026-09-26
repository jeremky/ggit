# ggit

A script that simplifies using Git. It automates updating multiple Git repositories with a single command.

## Configuration

The `ggit.cfg` file lets you define the following:

- The repository user
- The path to the parent directory
- The service hosting the repositories
- A secondary repository for pushes (**optional**)

```txt
# ggit config
user=$USER
gitdir=$(dirname "$0")/..
webgit=github.com
webclone=codeberg.org
```

## Usage

> If you run it from a directory containing a `.git` subdirectory, only that repository will be affected

- When run **without arguments** (or with `push`), the following commands are run on every directory containing a `.git` subdirectory (nothing is committed if the repository is already clean):

```bash
git add -A
git commit -m "Update"
git push
```

- `pull`: run `git pull` on all directories
- `status`: run `git status --short --branch` for all directories
- `garbage`: run a cleanup (`git gc`) on all directories
- `clone`: clones one or more repositories passed as arguments over SSH (`./ggit.sh clone my-repo other-repo`). If `webclone` is set in `ggit.cfg`, it is automatically added as a secondary push remote, so changes are pushed to a mirror repository at the same time
- `help`: shows help for the available commands
