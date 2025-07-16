# ggit.sh

Script simplifiant l'utilisation de Github. Il permet d'effectuer rapidement une mise à jour d'un ensemble de dossiers.

## Utilisation

- Utilisé sans paramètre, les commandes suivantes seront exécutées sur chaque dossier contenant un sous dossier `.git` :

```bash
git add *
git add .*
git commit -m "Mise à jour"
git push
```

- Avec le paramètre `pull`, un `git pull` sera effectué sans l'ensemble des dossiers

> Si le prompt est dans un dossier contenant un sous dossier `.git`, seul ce sous dossier sera concerné par la mise à jour

- Avec le paramètre `clone`, un clone via ssh sera effectué du repo en paramètre. N'indiquez que le chemin final de votre repo. Le nom de votre user github doit correspondre à votre user système
