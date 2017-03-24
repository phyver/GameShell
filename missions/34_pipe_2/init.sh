#!/bin/bash

# fichier lu par le shell à chaque démarage de la mission

rm -f $GASH_HOME/Echoppe/*
$GASH_LOCAL_BIN/genParchemin.py 10000 2000 0.995 > $GASH_HOME/Echoppe/${RANDOM}${RANDOM}_P_A_R_C_H_E_M_I_N_${RANDOM}${RANDOM}

echo -n "génération du l'échoppe : "
for i in `seq 1 5000` ; do
  touch $GASH_HOME/Echoppe/${RANDOM}${RANDOM}_objet_sans_interet_${RANDOM}${RANDOM}
  [ $(($i % 50)) -eq 0 ] && echo -n "."
done
echo

OLD_PROMPT_COMMAND=$PROMPT_COMMAND

NB_CMD=2
PROMPT_COMMAND='NB_CMD=$(( $NB_CMD - 1 )); echo "$NB_CMD commande(s) restante(s)"'

unset i

