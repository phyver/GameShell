#!/bin/bash

# mission soumise par Tiemen Duvillard

# une chaine aléatoire
ab=okduygvjilelctawqnucevoxhzdmkabbnqsyfpfjhtwrmgirspzx

# je choisis une clé en prenant un bout au hasard de la chaine ci dessus
_secret_key=${ab:( $RANDOM % ((${#ab}) -4) ):4}

# un décalage pas trop grand (entre -6 et +6) pour que la recherche exhaustive ne soit pas trop longue
decalage=7
while [ "$decalage" -eq 7 ]
do
    decalage=$((RANDOM %13)) # je choisi un décalage de cesar au hasard
done

ch=tuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrs
C=${ch:$decalage:26} # je crée mon alphabet d'arrivée en tronquand la chaine ci-dessus et en m'aidant du décalage de César

echo "voici mon testament :
je vous legue mon coffre et son contenu.
le coffre se situe dans la cave.
la cle pour le faire apparaitre est : $_secret_key
Merlin l'Enchanteur" | tr "a-z" $C > $GASH_HOME/Chateau/Batiment_principal/Bibliotheque/.message_secret # je crée le fichier dans la bibliotheque de Merlin

unset decalage ch C ab # je supprime mes variables, sauf _secret_key, dont on a besoin pour le gash check
