#!/bin/bash

# fichier lu par le shell à chaque démarrage de la mission

YYYY=$((1900 + RANDOM % 300))
MM=$( echo "00$((1 + RANDOM % 12))" | tail -c3 )
DD=$( echo "00$((13 + RANDOM % 5))" | tail -c3 )

echo "$YYYY-$MM-$DD" > $GSH_VAR/date

unset YYYY MM DD
