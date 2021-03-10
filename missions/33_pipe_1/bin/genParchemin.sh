#!/usr/bin/env bash

gen() {

    local nb_lignes=$1
    local pourcent_paye=$2
    local pourcent_roi=$3

    local prenoms=( 'Abdallah' 'Abdel' 'Adelaide' 'Adrien' 'Agnes' 'Alaric'
        'Ali' 'Ali' 'Alienor' 'Alix' 'Alphonse' 'Alphonse' 'Alwin' 'Amaury'
        'Amedee' 'Amin' 'Amina' 'Anastase' 'Anastase' 'Anastasie' 'Anastasie'
        'Ariane' 'Arnaud' 'Arnaut' 'Arthur' 'Arthur' 'Astrid' 'Aubin' 'Aude'
        'Aude' 'Audoin' 'Augustin' 'Aure' 'Avit' 'Avit' 'Aymar' 'Bathilde'
        'Bathilde' 'Baudoin' 'Baudry' 'Beatrice' 'Beatrice' 'Benedicte'
        'Benedicte' 'Benoit' 'Berenger' 'Bernard' 'Bernard' 'Berthe' 'Berthe'
        'Bertille' 'Bertille' 'Bertrand' 'Bertrand' 'Bilal' 'Blanche'
        'Blanche' 'Boniface' 'Boniface' 'Brice' 'Brunhild' 'Cassius'
        'Catherine' 'Catherine' 'Charles' 'Charles' 'Childebert' 'Clodomir'
        'Clotaire' 'Clotaire' 'Clotilde' 'Clotilde' 'Cloud' 'Cloud' 'Clovis'
        'Colin' 'Colomban' 'Colombe' 'Colombe' 'Constance' 'Constance'
        'Constantin' 'Crepin' 'Cyrielle' 'Dagobert' 'Didier' 'Djafar'
        'Domitille' 'Edouard' 'Edouard' 'Edwin' 'Elisabeth' 'Elizabeth' 'Eloi'
        'Eloi' 'Eloise' 'Elvira' 'Emeline' 'Emeline' 'Emma' 'Engueran'
        'Enguerrand' 'Eric' 'Ermeline' 'Etienne' 'Etienne' 'Eudes' 'Eudes'
        'Eulalie' 'Eulalie' 'Evrard' 'Fatima' 'Fatima' 'Ferdinand' 'Fernand'
        'Fernande' 'Fiacre' 'Fiacre' 'Firmin' 'Firmin' 'Flavien' 'Flavien'
        'Florentin' 'Florentin' 'Foulques' 'Frederic' 'Frederic' 'Fulbert'
        'Garcia' 'Gaspard' 'Gaston' 'Gaston' 'Gaultier' 'Gauthier' 'Gautier'
        'Gauvin' 'Genevieve' 'Geoffroy' 'Geoffroy' 'Gerald' 'Germain'
        'Germain' 'Gertrude' 'Gertrude' 'Gilbert' 'Gilbert' 'Gildas' 'Gildas'
        'Gisele' 'Goery' 'Gontran' 'Gontran' 'Gregoire' 'Gregoire' 'Guenievre'
        'Guillaume' 'Guillaume' 'Guy' 'Gysele' 'Hadi' 'Hafsa' 'Halima'
        'Haroun' 'Hassan' 'Heloïse' 'Hermance' 'Hermine' 'Hildegarde' 'Hisham'
        'Hubert' 'Hubert' 'Hugues' 'Hugues' 'Hussein' 'Ida' 'Idriss' 'Irene'
        'Isaac' 'Isabel' 'Isabelle' 'Iseult' 'Isidore' 'Jean' 'Jeanne'
        'Jeanne' 'Jehanne' 'Jimena' 'Joséphine' 'Julien' 'Justin' 'Justine'
        'Justinien' 'Khadidja' 'Lancelot' 'Louis' 'Louis' 'Louise' 'Lubin'
        'Mahaut' 'Malvina' 'Mansour' 'Marcus' 'Margaux' 'Margaux' 'Margot'
        'Margot' 'Marguerite' 'Maria' 'Maria' 'Mathilde' 'Mathilde' 'Maurice'
        'Maurice' 'Maurin' 'Melusine' 'Merlin' 'Morgane' 'Musa' 'Nestor'
        'Norbert' 'Ode' 'Ode' 'Odeline' 'Odile' 'Odile' 'Odilon' 'Ogier'
        'Olivier' 'Omar' 'Omer' 'Omer' 'Oswald' 'Pacome' 'Pacome' 'Paul'
        'Paulin' 'Paulin' 'Penda' 'Pepin' 'Pepin' 'Perceval' 'Petrus'
        'Philibert' 'Philibert' 'Philippe' 'Philippe' 'Pierre' 'Pierre'
        'Pierrick' 'Radegonde' 'Raoul' 'Raoul' 'Raymond' 'Remi' 'Renaud'
        'Richard' 'Robert' 'Robert' 'Robin' 'Robin' 'Roger' 'Roland' 'Roland'
        'Romain' 'Romaric' 'Samson' 'Sawda' 'Sebastien' 'Sigismond'
        'Stanislas' 'Sylvia' 'Tancrede' 'Tanguy' 'Tarik' 'Tariq' 'Tassilo'
        'Theodore' 'Thibaud' 'Thibert' 'Thierry' 'Thierry' 'Tiphaine'
        'Tiphaine' 'Tristan' 'Ulric' 'Ulrich' 'Urbain' 'Ursula' 'Ursule'
        'Venance' 'Venance' 'Veneranda' 'Victoire' 'Vincent' 'Vincent'
        'Virgile' 'Waldo' 'Wilfrid' 'Wilfried' 'William' 'Yazid' 'Zacharia'
        'Zacharie' )

    local noms=( 'fils de Martin' 'Langlois' 'Anglais' 'Duchesne' 'du Chêne'
        'Marchand' 'Boulanger' 'le Chauve' 'Courtois' 'Ageorges' 'Aubernard'
        'Alamartine' 'le fils à Georges' 'le fils au Bernard' 'Fromentin'
        'Rabier' 'Coulomb' 'Coulon' 'Cabrera' 'Poudevigne' 'Messonnier'
        'Métivier' 'Pelletier' 'Larsonneur' 'Legros' 'Lenain' 'Sarrazin'
        'Chauvin' 'Roux' )

    local objets=( 'une pelle' 'un pic' 'une besace' 'une pomme' 'une poule'
        'un cheval' 'une vache' 'une chèvre' 'un chacal' 'un sac de blé'
        'un rubis' 'un savon' 'une balle de cuir' 'une couverture'
        'un caillou brillant' 'une opale' 'un bâton de marche' 'une besace' 'un tabouret'
        'une épingle' 'une ceinture' 'un heaume' )

    local _ prenom nom objet prix paye
    local dette=0
    for _ in $(seq "$nb_lignes")
    do
        objet=${objets[$(( 16#$RANDOM % ${#objets[@]}))]}
        prix=$(( RANDOM % 5 + 2))
        paye=$([ $((RANDOM % 100)) -le "$pourcent_paye" ] && echo " -- PAYÉ")

        if [ $(( RANDOM % 100 )) -le "$pourcent_roi" ]
        then
            prenom="Le"
            nom="Duc"
            if [ -z "$paye" ]
            then
                dette=$(( dette + prix ))
            fi
        else
            prenom=${prenoms[$(( 16#$RANDOM % ${#prenoms[@]}))]}
            nom=${noms[$(( 16#$RANDOM % ${#noms[@]}))]}
        fi
        echo "$prenom $nom m'a acheté $objet pour $prix piécettes$paye"
    done

}

gen "$1" "$2" "$3"
