#!/bin/bash

# mission originaly created by Tiemen Duvillard

# je choisis une clé en prenant un bout au hasard de la chaine ci dessus
SECRET_KEY=$(random_string 4 | tr A-Z a-z)
# TODO, only store hash of key?
echo "$SECRET_KEY" > "$GSH_VAR/secret_key"

random_shift=$((12 + RANDOM % 3))

ab=abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
D=${ab:random_shift:26} # je crée mon alphabet d'arrivée en tronquand la chaine ci-dessus et en m'aidant du décalage de César

echo "$(eval_gettext "here is my will:
you will get my chest, and everything it contains.
this check is in the cellar, and the key to make
it re-appear is: \$SECRET_KEY
merlin the enchanter")" | tr "a-z" "$D" > "$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office/Drawer')/$(gettext 'secret_message')"

unset rd SECRET_KEY random_shift ab D
