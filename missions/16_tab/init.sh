#!/bin/bash

# fichier lu par le shell à chaque démarrage de la mission

corridor="$(find "$(eval_gettext '$GSH_HOME/Castle/Cellar')" -type d -name "$(gettext ".Long*Corridor*")")"
if [ -z "$corridor" ]
then
    r1=$(checksum $RANDOM)
    r2=$(checksum $RANDOM)
    corridor="$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(eval_gettext '.Long $r1 Corridor $r2')"
    mkdir -p "$corridor"
fi

basename "$corridor" | checksum > "$GSH_VAR/corridor"

unset corridor r1 r2
