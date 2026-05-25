# ggit

Script simplifiant l'utilisation de Git. Il automatise la mise à jour de plusieurs dépôts Git en une seule commande.

## Configuration

Le fichier `ggit.cfg` permet de définir les éléments suivants :

- L'utilisateur du dépôt
- Le chemin du dossier parent
- Le service où se trouve les dépôts

```txt
# ggit config
user=$USER
gitdir=$(dirname "$0")/..
webgit=codeberg.org
```

## Utilisation

> Si le prompt est dans un dossier contenant un sous dossier `.git`, seul ce sous dossier sera concerné par la mise à jour

- Utilisé **sans paramètre**, les commandes suivantes seront exécutées sur chaque dossier contenant un sous dossier `.git` :

```bash
git add -A
git commit -m "Update"
git push
```

- Avec le paramètre `pull`, un `git pull` sera effectué sur l'ensemble des dossiers
- Avec le paramètre `garbage`, un nettoyage (`git gc`) sera effectué sur l'ensemble des dossiers
- Avec le paramètre `clone`, clone via SSH le dépôt passé en paramètre (`./ggit.sh clone mon-repo`)
