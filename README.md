# ggit.sh

Script simplifiant l'utilisation de Github. Il permet d'effectuer rapidement une mise à jour d'un ensemble de dossiers.

## Utilisation

Un fichier de configuration est présent pour définir le dossier racine :

```bash
# ggit config
user=$(id -un 1000)
gitdir="$HOME/scripts"
message="Mise à jour"
```

- Utilisé sans paramètre, les commandes suivantes seront exécutées sur chaque dossier contenant un sous dossier `.git` :

```bash
git add *
git add .*
git commit -m "$message"
git push
```

- Avec le paramètre `pull`, un `git pull` sera effectué sans l'ensemble des dossiers.

> Si le prompt est dans un dossier contenant un sous dossier `.git`, seul ce sous dossier sera concerné par la mise à jour

- Avec le paramètre `clone`, un clone via ssh sera effectué du repo en paramètre. N'indiquez que le nom du dossier, le chemin complet sera constitué à partir du nom du user présent dans le fichier de configuration.
