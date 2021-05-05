find "$GASH_HOME" -iname "*$(gettext "Hut")*" -print0 | xargs -0 rm -rf
find "$GASH_HOME" -iname "*$(gettext "Chest")*" -print0 | xargs -0 rm -rf

gash assert check false

mkdir "$(eval_gettext '$GASH_HOME/Forest')/hut"
mkdir "$(eval_gettext '$GASH_HOME/Forest')/hut/chest"
gash assert check false

mkdir "$(eval_gettext '$GASH_HOME/Forest')/Hut"
mkdir "$(eval_gettext '$GASH_HOME/Forest')/Chest"
gash assert check false

mkdir "$(eval_gettext '$GASH_HOME/Forest')/Hut"
mkdir "$(eval_gettext '$GASH_HOME/Forest')/Chest"
mkdir "$(eval_gettext '$GASH_HOME/Forest')/Hut/Chest"
gash assert check false

mkdir "$(eval_gettext '$GASH_HOME/Forest')/Hut"
mkdir "$(eval_gettext '$GASH_HOME/Forest')/Chest"
mkdir "$(eval_gettext '$GASH_HOME/Forest')/Hut/Chest"
gash assert check false

mkdir "$(eval_gettext '$GASH_HOME/Forest')/Hut"
mkdir "$(eval_gettext '$GASH_HOME/Forest')/Hut/Chest"
gash assert check true
