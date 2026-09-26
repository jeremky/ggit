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

> If the prompt is in a directory containing a `.git` subdirectory, only that repository will be affected

- Run **without arguments** (or with `push`), the following commands are run on every directory containing a `.git` subdirectory (nothing is committed if the repository is already clean):

```bash
git add -A
git commit -m "Update"
git push
```

- With the `pull` argument, a `git pull` is run on all directories
- With the `status` argument, a `git status --short --branch` is shown for all directories
- With the `garbage` argument, a cleanup (`git gc`) is run on all directories
- With the `clone` argument, clones one or more repositories passed as arguments over SSH (`./ggit.sh clone my-repo other-repo`). If `webclone` is set in `ggit.cfg`, it is automatically added as a secondary push remote, so changes are pushed to a mirror repository at the same time
- With the `help` argument, shows help for the available commands
