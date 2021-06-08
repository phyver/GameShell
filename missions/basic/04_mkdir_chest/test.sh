find "$GSH_HOME" -iname "*$(gettext "Hut")*" -print0 | xargs -0 rm -rf
find "$GSH_HOME" -iname "*$(gettext "Chest")*" -print0 | xargs -0 rm -rf

gsh assert check false

## this test doesn't work on macOS because of case distinction on filenames
# mkdir "$(eval_gettext '$GSH_HOME/Forest')/$(gettext "Hut" | tr 'A-Z' 'a-z')"
# mkdir "$(eval_gettext '$GSH_HOME/Forest')/$(gettext "Hut" | tr 'A-Z' 'a-z')/$(gettext "Chest" | tr 'A-Z' 'a-z')"
# gsh assert check false

mkdir "$(eval_gettext '$GSH_HOME/Forest')/$(gettext "Hut")"
mkdir "$(eval_gettext '$GSH_HOME/Forest')/$(gettext "Chest")"
gsh assert check false

mkdir "$(eval_gettext '$GSH_HOME/Forest')/$(gettext "Hut")"
mkdir "$(eval_gettext '$GSH_HOME/Forest')/$(gettext "Chest")"
mkdir "$(eval_gettext '$GSH_HOME/Forest')/$(gettext "Hut")/$(gettext "Chest")"
gsh assert check false

mkdir "$(eval_gettext '$GSH_HOME/Forest')/$(gettext "Hut")"
mkdir "$(eval_gettext '$GSH_HOME/Forest')/$(gettext "Chest")"
mkdir "$(eval_gettext '$GSH_HOME/Forest')/$(gettext "Hut")/$(gettext "Chest")"
gsh assert check false

mkdir "$(eval_gettext '$GSH_HOME/Forest')/$(gettext "Hut")"
mkdir "$(eval_gettext '$GSH_HOME/Forest')/$(gettext "Hut")/$(gettext "Chest")"
gsh assert check true
