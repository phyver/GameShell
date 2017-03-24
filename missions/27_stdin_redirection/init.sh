cat >$GASH_HOME/Chateau/Batiment_principal/Bibliotheque/Latin_et_autres_langues  <<EOB
Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat.  Duis aute irure dolor in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
EOB

cat >$GASH_HOME/Chateau/Batiment_principal/Bibliotheque/.Comment_tricher_aux_examens  <<EOB
Le livre "Mathematiques pour debutants" contient toutes
les réponses pour l'examen...

Il suffit donc de recopier toutes les lignes de ce livre.
EOB

book=$GASH_HOME/Chateau/Batiment_principal/Bibliotheque/Mathematiques_pour_debutants
questions=$GASH_TMP/arith.txt
rm -f $questions


rm -rf $questions
for i in $(seq 100)
do
    a=$((1+$RANDOM%100))
    b=$((1+$RANDOM%100))
    c=$(($a * $b))
    echo $c >> $book
    echo "$a * $b = ?? |$c" >> $questions
done
