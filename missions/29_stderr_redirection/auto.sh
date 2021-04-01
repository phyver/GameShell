cd ~/Chateau/Batiment_principal/Bibliotheque/Bureau_de_Merlin/

# les commandes ne sont pas dans l'historique, il faut les y ajouter à la main !
history -s 'grep -il "pq" grimoire_* 2> /dev/null'
history -s gash check

grep -il "pq" grimoire_* 2> /dev/null
gash check

history -d -2--1

