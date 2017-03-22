#!/bin/bash

# script pour tester la completion de la mission
# le script doit faire ``echo OK`` en cas de succes
# toute autre valeur sera considérée comme un echec
#

if $(LANG=C jobs | grep "xeyes.*&" | grep -qi running)
then
    true
else
    jobs -p | xargs kill -9
    false
fi


