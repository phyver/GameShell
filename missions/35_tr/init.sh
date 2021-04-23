#!/bin/bash

# mission originaly created by Tiemen Duvillard

# une chaine aléatoire
rd=pylptbbpbqmtaojeqalfrdzfswddcicuwtohudysakdtzqcswwzyrfwbilbkkusz

# je choisis une clé en prenant un bout au hasard de la chaine ci dessus
SECRET_KEY="${rd:( $RANDOM % ((${#rd}) -4) ):4}"
echo "$SECRET_KEY" > "$GASH_MISSION_DATA/secret_key"

random_shift=$((3 + RANDOM % 20))

ab=abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
D=${ab:random_shift:26} # je crée mon alphabet d'arrivée en tronquand la chaine ci-dessus et en m'aidant du décalage de César

echo "$(eval_gettext "here is my will:
you will get my chest, and everything it contains.
this check is in the cellar, and the key to make
it re-appear is: \$SECRET_KEY
merlin the enchanter")" | tr "a-z" "$D" > "$(eval_gettext '$GASH_HOME/Castle/Main_building/Library/.secret_message')"

unset rd SECRET_KEY random_shift ab D
