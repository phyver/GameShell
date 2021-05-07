find "$GSH_HOME" -iname "*$(gettext "Hut")*" -print0 | xargs -0 rm -rf
find "$GSH_HOME" -iname "*$(gettext "Chest")*" -print0 | xargs -0 rm -rf

gsh assert check false

mkdir "$(eval_gettext '$GSH_HOME/Forest')/hut"
mkdir "$(eval_gettext '$GSH_HOME/Forest')/hut/chest"
gsh assert check false

mkdir "$(eval_gettext '$GSH_HOME/Forest')/Hut"
mkdir "$(eval_gettext '$GSH_HOME/Forest')/Chest"
gsh assert check false

mkdir "$(eval_gettext '$GSH_HOME/Forest')/Hut"
mkdir "$(eval_gettext '$GSH_HOME/Forest')/Chest"
mkdir "$(eval_gettext '$GSH_HOME/Forest')/Hut/Chest"
gsh assert check false

mkdir "$(eval_gettext '$GSH_HOME/Forest')/Hut"
mkdir "$(eval_gettext '$GSH_HOME/Forest')/Chest"
mkdir "$(eval_gettext '$GSH_HOME/Forest')/Hut/Chest"
gsh assert check false

mkdir "$(eval_gettext '$GSH_HOME/Forest')/Hut"
mkdir "$(eval_gettext '$GSH_HOME/Forest')/Hut/Chest"
gsh assert check true
