#!/bin/bash

cd "$(eval_gettext '$GASH_HOME/Mountain/Cave')"

# les commandes ne sont pas dans l'historique, il faut les y ajouter à la main !
history -s "head -n 11 \"$(gettext "potion_recipe")\" | tail -n 3"
history -s gash check

head -n 11 "$(gettext "potion_recipe")" | tail -n 3
gash check

history -d -2--1

