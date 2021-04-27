find "$GASH_HOME" -iname "*$(gettext "Cabin")*" -print0 | xargs -0 rm -rf
find "$GASH_HOME" -iname "*$(gettext "Chest")*" -print0 | xargs -0 rm -rf

gash assert check false

mkdir "$(eval_gettext '$GASH_HOME/Forest')/cabin"
mkdir "$(eval_gettext '$GASH_HOME/Forest')/cabin/chest"
gash assert check false

mkdir "$(eval_gettext '$GASH_HOME/Forest')/Cabin"
mkdir "$(eval_gettext '$GASH_HOME/Forest')/Chest"
gash assert check false

mkdir "$(eval_gettext '$GASH_HOME/Forest')/Cabin"
mkdir "$(eval_gettext '$GASH_HOME/Forest')/Chest"
mkdir "$(eval_gettext '$GASH_HOME/Forest')/Cabin/Chest"
gash assert check false

mkdir "$(eval_gettext '$GASH_HOME/Forest')/Cabin"
mkdir "$(eval_gettext '$GASH_HOME/Forest')/Chest"
mkdir "$(eval_gettext '$GASH_HOME/Forest')/Cabin/Chest"
gash assert check false

mkdir "$(eval_gettext '$GASH_HOME/Forest')/Cabin"
mkdir "$(eval_gettext '$GASH_HOME/Forest')/Cabin/Chest"
gash assert check true
