# Ce fichier est chargé (ou "sourcé" dans le jargon du shell) au
# lancement du jeu. Il peut être utilisé pour définir des alias
# (et aussi d'autres choses) qui sont sauvegardés entre sessions
# de jeu. En effet, un alias défini dans le shell sera "oublié"
# en fin de session s'il n'est pas ajouté ici. (Un alias défini
# dans le cadre d'une mission est sauvegardés pour vous.)
#
# Remarque: ici, les lignes commençant par '#' sont ignorées.
# Les shells usuels utilisent un tels fichier, habituellement
# caché dans le répertoire de départ. Pour bash, ce fichier se
# trouve au chemin
#       ~/.bashrc

# Les définitions de ce fichier ne sont pas ajoutées directement
# au shell courant. Vous pouvez cependant utiliser le raccourci
# suivant pour ajouter les ajouter manuellement.
alias reload="source $GSH_CHEST/bashrc"

# Voici quelques idées d'alias qui peuvent être utiles :
# - un alias "gg" pour "gsh goal",
# - un alias "gc" pour "gsh check",
# - un alias "editrc" pour éditer ce fichier avec nano.
