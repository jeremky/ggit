# ggit.sh

Script simplifiant l'utilisation de Github. Il permet d'effectuer rapidement une mise à jour d'un ensemble de dossiers.

## Utilisation

Un fichier de configuration est présent pour définir le dossier racine :

```bash
# ggit config
gitdir="$HOME/scripts"
message="Mise à jour"
```

Les commandes suivantes seront alors exécutées sur chaque dossier contenant un sous dossier `.git` :

```bash
git add *
git add .*
git commit -m "$message"
git push
```
