#!/bin/bash

cd "$(eval_gettext '$GASH_HOME/Mountain/Cave')"

# les commandes ne sont pas dans l'historique, il faut les y ajouter à la main !
history -s tail -n 4  $(gettext "potion_ingredients")
history -s gash check

tail -n 4  $(gettext "potion_ingredients")
gash check

history -d -2--1

