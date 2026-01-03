#!/usr/bin/env bash

# Main lore generation function —————————————————————————————————————————————
generate_lore() {

    # Helpers ————————————————————————————————————————————————————————————————
    mkd() {
        mkdir -p "$1";
    }

    link() {
        local dest="$1";
        local target="$2";
        mkd "$(dirname "$dest")";
        ln -sfn "$target" "$dest";
    }

    writ() { # writ "path" "content"
        local path="$1"; mkd "$(dirname "$path")"
        printf "%s\n" "$2" > "$path"
    }

    heredoc() { # heredoc "path" <<'EOF' ... EOF
        local path="$1"; mkd "$(dirname "$path")"; cat > "$path"
    }

    echo "$(eval_gettext "🖋️  Generating lore for the Kingdom of Bordereau VI the Stamped (edition without villages)...")"
    ROOT="$(eval_gettext "\$GSH_HOME/Royaume")"

    # Château ————————————————————————————————————————————————————————————————
    mkd "$ROOT/Château/Tour principale/Premier étage/Deuxième étage/Sommet de la tour"
    mkd "$ROOT/Château/Objets"
    writ "$ROOT/Château/Tour principale/Premier étage/Journal du Concierge.txt" \
        "Jour 34 : quelqu'un a déplacé le sablier des audiences. Le temps est désormais en avance sur lui-même."
    writ "$ROOT/Château/Objets/Tampon royal (bois de licorne).txt" \
        "Usage : apposer. Effet secondaire : respect instantané."
    writ "$ROOT/Château/Objets/Clé du tiroir des clés.txt" \
        "N'ouvre que les clés. Pour les tiroirs, prévoir un autre formulaire."
    writ "$ROOT/Château/Objets/Parapheur de Parade (trop lourd pour servir).txt" \
        "Objet cérémoniel. Apparaît plus officiel que la loi."

    writ "$ROOT/Château/Portraits officiels/Bordereau VI le Tamponné.txt" \
        "Roi, amateur de procédures claires et de tampons opaques. Devise : « Qui tamponne règne. »"

    # Administration centrale ——————————————————————————————————————————————
    mkd "$ROOT/Administration centrale/Hôtel du Roi/Grande Chancellerie/Bureau des Tampons"
    mkd "$ROOT/Administration centrale/Hôtel du Roi/Antichambre/Salle d'attente"
    mkd "$ROOT/Administration centrale/Ministère des Papiers/Direction des Formulaires"
    mkd "$ROOT/Administration centrale/Ministère des Papiers/Service du Duplicata"
    mkd "$ROOT/Administration centrale/Ministère des Ponts et Chemins/Bureau des Montages"
    mkd "$ROOT/Administration centrale/Ministère des Rumeurs/Cabinet des Murmures"
    mkd "$ROOT/Administration centrale/Cour des Comptes et Demi Comptes/Greffe"
    mkd "$ROOT/Administration centrale/Préfecture du Royaume/Guichet A-M"
    mkd "$ROOT/Administration centrale/Préfecture du Royaume/Guichet N-Z"
    mkd "$ROOT/Administration centrale/Archives/Rayonnages/A à Z"
    mkd "$ROOT/Administration centrale/Commissions/Commission 1"
    mkd "$ROOT/Administration centrale/Commissions/Commission 2"
    mkd "$ROOT/Administration centrale/Commissions/Commission 3"

    # Règlements, circulaires et murmures ————————————————————————————————————
    writ "$ROOT/Administration centrale/Hôtel du Roi/Antichambre/Salle d'attente/Numéro 0001.txt" \
        "Vous serez appelé après le numéro 0000 (quand il existera)."

    heredoc "$ROOT/Administration centrale/Hôtel du Roi/Grande Chancellerie/Bureau des Tampons/Règlement intérieur.md" <<'EOF'
# Règlement intérieur du Bureau des Tampons
1. Toute demande doit être tamponnée avant d'être déposée pour être tamponnée.
2. Les tampons ne sont pas à tamponner, sauf en cas d'urgence (formulaire « URG-URG »).
3. Les employés doivent apaiser le tampon à plumes chaque matin.
EOF

    writ "$ROOT/Administration centrale/Ministère des Papiers/Direction des Formulaires/Procédure circulaire n° ∞.md" \
        "Étape 1 : consulter l'Étape 2. Étape 2 : consulter l'Étape 1. (Tampon requis à chaque consultation.)"

    writ "$ROOT/Administration centrale/Ministère des Rumeurs/Cabinet des Murmures/Murmure du jour.txt" \
        "On dit que la pile de dossiers est plus haute vue d'en bas."

    writ "$ROOT/Administration centrale/Cour des Comptes et Demi Comptes/Greffe/Demi-reçu (à compléter).txt" \
        "Merci de présenter l'autre moitié pour prouver l'existence de celle-ci."

    writ "$ROOT/Administration centrale/Archives/Rayonnages/A à Z/Index (partiel).txt" \
        "Abricots (non) ; Attestations (oui) ; Avertissements (peut-être). Voir aussi : Zèbres (classés à A par erreur)."

    # Objets farfelus répartis dans les services —————————————————————————————————
    writ "$ROOT/Administration centrale/Hôtel du Roi/Antichambre/Salle d'attente/Plante en plastique (titulaire d'un badge).txt" \
        "Ancienneté : 12 ans. Droits acquis : priorité au guichet."
    writ "$ROOT/Administration centrale/Hôtel du Roi/Grande Chancellerie/Bureau des Tampons/Tampon quantique.txt" \
        "Appose et retire le cachet simultanément jusqu'à observation par un supérieur."
    writ "$ROOT/Administration centrale/Hôtel du Roi/Grande Chancellerie/Bureau des Tampons/Encrier sans fond.txt" \
        "Déficit structurel. Voté chaque année par acclamation."
    writ "$ROOT/Administration centrale/Ministère des Papiers/Direction des Formulaires/Distributeur à formulaires aléatoires.txt" \
        "Crache un CERFA différent à chaque juron. Ne prend pas la monnaie."
    writ "$ROOT/Administration centrale/Ministère des Papiers/Service du Duplicata/Photocopie d'une copie originale introuvable.txt" \
        "Authentifiée par l'absence de l'original."
    writ "$ROOT/Administration centrale/Ministère des Ponts et Chemins/Bureau des Montages/Niveau à bulle vertical.txt" \
        "Indique l'inclinaison morale du projet."
    writ "$ROOT/Administration centrale/Ministère des Rumeurs/Cabinet des Murmures/Micro murmurant.txt" \
        "Répète « il paraît » avec autorité."
    writ "$ROOT/Administration centrale/Cour des Comptes et Demi Comptes/Greffe/Abacus numérique (débranché).txt" \
        "Optimise les économies invisibles."
    writ "$ROOT/Administration centrale/Préfecture du Royaume/Guichet A-M/Automate à tickets régurgitateurs.txt" \
        "Rend un ticket plus ancien que le vôtre."
    writ "$ROOT/Administration centrale/Préfecture du Royaume/Guichet N-Z/Corde serpent de file d'attente.txt" \
        "S'allonge dès qu'on croit toucher au but."
    writ "$ROOT/Administration centrale/Archives/Rayonnages/A à Z/Dossier de Schrödinger (classé et perdu).txt" \
        "Existe tant que personne ne le consulte."

    # Commissions (avec membres + objets) ——————————————————————————————————————
    heredoc "$ROOT/Administration centrale/Commissions/Commission 1/Liste des membres.txt" <<'EOF'
- Dame Pénélope de la Punaise (présidente)
- Sire Fernand du Parapheur (vice-président)
- Maître Loris des Liasses (rapporteur)
EOF
    writ "$ROOT/Administration centrale/Commissions/Commission 1/Cloche de séance (muette).txt" \
        "Signale la fin du débat dès qu'il commence."

    heredoc "$ROOT/Administration centrale/Commissions/Commission 2/Liste des membres.txt" <<'EOF'
- Capitaine Clotaire du Cachet
- Demoiselle Agathe du Bordereau
- Frère Nestor des Annexes
EOF
    writ "$ROOT/Administration centrale/Commissions/Commission 2/Chaise pliante (dépliée par arrêté).txt" \
        "Ne se plie qu'aux injonctions écrites."

    heredoc "$ROOT/Administration centrale/Commissions/Commission 3/Liste des membres.txt" <<'EOF'
- Intendante Salomé de la Signature
- Greffier Octave de l'Agrafe
- Sergente Éline de la Reliure
EOF
    writ "$ROOT/Administration centrale/Commissions/Commission 3/Agrafeuse protocolaire (sans agrafes).txt" \
        "Réunit sans attacher."

    # —————————————————————————————————————————————————————————————————————————————
    # ACADÉMIE DE GÉO-MANCIE (nouvelle section)
    # —————————————————————————————————————————————————————————————————————————————
    mkd "$ROOT/Académie de Géo-mancie/Secrétariat des Études/Bureau des Inscriptions"
    mkd "$ROOT/Académie de Géo-mancie/Secrétariat des Études/Service des Rattrapages"
    mkd "$ROOT/Académie de Géo-mancie/Bibliothèque des Cartes Impossibles/Salle des Atlas Contradictoires"
    mkd "$ROOT/Académie de Géo-mancie/Bibliothèque des Cartes Impossibles/Rez-de-chaussée/Index mouvant"
    mkd "$ROOT/Académie de Géo-mancie/Départements/Cartographie Éthérique/Labos"
    mkd "$ROOT/Académie de Géo-mancie/Départements/Topologie des Tampons/Labos"
    mkd "$ROOT/Académie de Géo-mancie/Départements/Géologie des Formulaires/Labos"
    mkd "$ROOT/Académie de Géo-mancie/Institut des Flux et Contre-Flux/Amphithéâtre ∮"
    mkd "$ROOT/Académie de Géo-mancie/Observatoire des Lignes Administratives/Terrasse des Méridiens"
    mkd "$ROOT/Académie de Géo-mancie/Concours et Agrégations/Salle des Épreuves"
    mkd "$ROOT/Académie de Géo-mancie/Musée des Outils/Instruments"

    # Règlements et présentation
    heredoc "$ROOT/Académie de Géo-mancie/Secrétariat des Études/Guide de l'étudiant.md" <<'EOF'
# Guide de l'étudiant géo-mancien
- Principe cardinal : tout territoire est une question de papier.
- Les crédits ECTS signifient « Échelons, Cachets, Tampons, Signatures ».
- Toute carte valide doit comporter au moins un cul-de-sac administratif.
EOF

    writ "$ROOT/Académie de Géo-mancie/Secrétariat des Études/Bureau des Inscriptions/Heures d'ouverture.txt" \
        "Ouvert les jours ouvrés pairs, sauf quand c'est impair."

    # Bibliothèque et objets
    writ "$ROOT/Académie de Géo-mancie/Bibliothèque des Cartes Impossibles/Salle des Atlas Contradictoires/Atlas plat de la Terre ronde.txt" \
        "Edition révisée : désormais sphéri-plate selon décret."
    writ "$ROOT/Académie de Géo-mancie/Bibliothèque des Cartes Impossibles/Rez-de-chaussée/Index mouvant/Mode d'emploi.txt" \
        "Pour trouver A, chercher Z, puis revenir à A par le couloir Bêta."

    # Départements — enseignants, cours, objets
    heredoc "$ROOT/Académie de Géo-mancie/Départements/Cartographie Éthérique/Programme.md" <<'EOF'
## Cartographie Éthérique — Programme
- Introduction à la calque-thérapie
- Géométrie variable des frontières morales
- Séminaire : Le compas qui hésite
EOF
    writ "$ROOT/Académie de Géo-mancie/Départements/Cartographie Éthérique/Labos/Compas indécis.txt" \
        "Tourne jusqu'à la présence d'un chef de service."

    heredoc "$ROOT/Académie de Géo-mancie/Départements/Topologie des Tampons/Programme.md" <<'EOF'
## Topologie des Tampons — Programme
- Groupes de cachets non commutatifs
- Homotopie des circuits de validation
- Séminaire : Tore des files d'attente
EOF
    writ "$ROOT/Académie de Géo-mancie/Départements/Topologie des Tampons/Labos/Tampon de Möbius.txt" \
        "Un seul côté, deux files, aucune issue."

    heredoc "$ROOT/Académie de Géo-mancie/Départements/Géologie des Formulaires/Programme.md" <<'EOF'
## Géologie des Formulaires — Programme
- Stratigraphie des annexes
- Métamorphisme sous parapheur
- Séminaire : Fossiles de versions
EOF
    writ "$ROOT/Académie de Géo-mancie/Départements/Géologie des Formulaires/Labos/Coupe stratifiée d'un dossier.txt" \
        "Observer sans déranger la couche fragile « pièces manquantes »."

    # Institut des Flux
    writ "$ROOT/Académie de Géo-mancie/Institut des Flux et Contre-Flux/Amphithéâtre ∮/Tableau noir auto-effaceur.txt" \
        "Efface les démonstrations juste avant la conclusion."

    # Observatoire
    writ "$ROOT/Académie de Géo-mancie/Observatoire des Lignes Administratives/Terrasse des Méridiens/Lunette à paperasse.txt" \
        "Ne grossit que les signatures illisibles."

    # Musée des Outils
    writ "$ROOT/Académie de Géo-mancie/Musée des Outils/Instruments/Planchette à tracer les délais.txt" \
        "Permet d'ajouter un mois calendaire à tout retard naturel."

    # Concours — épreuves, sujets, résultats
    heredoc "$ROOT/Académie de Géo-mancie/Concours et Agrégations/Salle des Épreuves/Sujet type.md" <<'EOF'
# Agrégation de Géo-mancie administrative — Sujet type
1) Cartographier une frontière mobile entre deux guichets fermés.
2) Démontrer l'existence d'un raccourci plus long que le détour officiel.
3) Tamponner l'hypothèse, puis la retirer proprement.
EOF
    writ "$ROOT/Académie de Géo-mancie/Concours et Agrégations/Salle des Épreuves/Copion homologué (vierge).txt" \
        "À remplir uniquement par inadvertance."

    # Offices spécialisés ——————————————————————————————————————————————————————
    mkd "$ROOT/Offices/Office unique du Tampon/Guichet"
    mkd "$ROOT/Offices/Office unique du Tampon/Contre-guichet"
    mkd "$ROOT/Offices/Office unique du Tampon/Service du Retour"
    mkd "$ROOT/Offices/Office des Cerfas/CERFA 13B"
    mkd "$ROOT/Offices/Office des Cerfas/CERFA 13C"
    mkd "$ROOT/Offices/Office des Plaintes et Demandes de Plaintes"

    writ "$ROOT/Offices/Office des Plaintes et Demandes de Plaintes/Exemple de plainte (modèle).txt" \
        "Objet : plainte contre le formulaire de plainte, trop plaintif."
    writ "$ROOT/Offices/Office unique du Tampon/Guichet/Plaquette d'orientation.txt" \
        "Pour toute question, adressez-vous au Contre-guichet. Pour contester : Service du Retour."
    writ "$ROOT/Offices/Office des Cerfas/CERFA 13B/Notice d'utilisation.txt" \
        "Remplir en bleu. Sauf si vous n'avez pas de bleu, dans ce cas : recommencer en bleu."

    # Objets des Offices
    writ "$ROOT/Offices/Office unique du Tampon/Guichet/Sablier administratif réglé sur « en cours ».txt" \
        "Ne se vide jamais entièrement, conformément à la procédure."
    writ "$ROOT/Offices/Office unique du Tampon/Contre-guichet/Stylo à encre conditionnelle.txt" \
        "Écrit uniquement après le tampon, jamais avant."
    writ "$ROOT/Offices/Office unique du Tampon/Service du Retour/Boîte à contestations (sans fond).txt" \
        "Toutes les réclamations y trouvent une chute."
    writ "$ROOT/Offices/Office des Cerfas/CERFA 13C/Formulaire auto-référencé.txt" \
        "Veuillez joindre le CERFA 13C à ce CERFA 13C."
    writ "$ROOT/Offices/Office des Plaintes et Demandes de Plaintes/Mégaphone chuchoteur.txt" \
        "Amplifie les silences indignés."

    # Parcours kafkaïen en 10 étapes (boucle assurée) ————————————————————————————
    steps=(
        "Accueil du Public"
        "Distribution de Tickets"
        "Orientation Provisoire"
        "Pré-validation Préliminaire"
        "Contrôle de Conformité aux Contrôles"
        "Visa de Préfecture Interne"
        "Tamponnage d'Intention"
        "Vérification de la Vérification"
        "Contre-Validation de l'Avant-Dernière Étape"
        "Guichet n°0"
    )
    base="$ROOT/Administration centrale/Parcours Administratif Standard"
    prev=""
    for s in "${steps[@]}"; do
        mkd "$base/$s"
        writ "$base/$s/Consignes.txt" "Présenter le document obtenu à l'étape précédente."
        # Ajouter un objet absurde propre à l'étape
        case "$s" in
            "Accueil du Public")
                writ "$base/$s/Plafonnier motivant.txt" "Affiche « Presque fini ! » dès l'arrivée."
                ;;
            "Distribution de Tickets")
                writ "$base/$s/Ticket à numéro imaginaire.txt" "Servi après les réels, avant les prioritaires."
                ;;
            "Orientation Provisoire")
                writ "$base/$s/Boussole administrative.txt" "Pointe toujours vers le guichet d'en face."
                ;;
            "Pré-validation Préliminaire")
                writ "$base/$s/Tampon d'ombre.txt" "Laisse une trace invisible mais réglementaire."
                ;;
            "Contrôle de Conformité aux Contrôles")
                writ "$base/$s/Checklist de la checklist.txt" "Dernier item : vérifier cette checklist."
                ;;
            "Visa de Préfecture Interne")
                writ "$base/$s/Porte battante (ne mène nulle part).txt" "Homologuée pour le va-et-vient."
                ;;
            "Tamponnage d'Intention")
                writ "$base/$s/Formulaire d'intentions tacites.txt" "À remplir sans rien écrire."
                ;;
            "Vérification de la Vérification")
                writ "$base/$s/Loupe protocolaire.txt" "Grossit la paperasse, réduit l'espoir."
                ;;
            "Contre-Validation de l'Avant-Dernière Étape")
                writ "$base/$s/Cachet contradictoire.txt" "Valide et invalide en même temps."
                ;;
            "Guichet n°0")
                writ "$base/$s/Clochette impossible.txt" "Sonnerie prévue au prochain exercice budgétaire."
                ;;
        esac

        if [[ -n "${prev}" ]]; then
            link "$base/$prev/Étape suivante" "$base/$s"
        fi
        prev="$s"
    done
    # boucle vers le début
    link "$base/Guichet n°0/Retour au début" "$base/Accueil du Public"

    # Liens absurdes inter-services ————————————————————————————————————————————
    # 1) “Guichet unique” ↔ “Salle d'attente”
    link "$ROOT/Administration centrale/Guichet unique" \
         "$ROOT/Administration centrale/Hôtel du Roi/Antichambre/Salle d'attente"
    link "$ROOT/Administration centrale/Hôtel du Roi/Antichambre/Salle d'attente/retour au guichet" \
         "$ROOT/Administration centrale/Guichet unique"

    # 2) Bureau des Tampons ↔ Service du Duplicata
    link "$ROOT/Administration centrale/Hôtel du Roi/Grande Chancellerie/Bureau des Tampons/Demandes de duplicata" \
         "$ROOT/Administration centrale/Ministère des Papiers/Service du Duplicata"
    link "$ROOT/Administration centrale/Ministère des Papiers/Service du Duplicata/Validation finale" \
         "$ROOT/Administration centrale/Hôtel du Roi/Grande Chancellerie/Bureau des Tampons"

    # 3) Préfecture : A-M ↔ N-Z
    link "$ROOT/Administration centrale/Préfecture du Royaume/Guichet A-M/prochain guichet" \
         "$ROOT/Administration centrale/Préfecture du Royaume/Guichet N-Z"
    link "$ROOT/Administration centrale/Préfecture du Royaume/Guichet N-Z/renvoi" \
         "$ROOT/Administration centrale/Préfecture du Royaume/Guichet A-M"

    # 4) Commissions en cercle
    link "$ROOT/Administration centrale/Commissions/Commission 1/transmission" \
         "$ROOT/Administration centrale/Commissions/Commission 2"
    link "$ROOT/Administration centrale/Commissions/Commission 2/transmission" \
         "$ROOT/Administration centrale/Commissions/Commission 3"
    link "$ROOT/Administration centrale/Commissions/Commission 3/transmission" \
         "$ROOT/Administration centrale/Commissions/Commission 1"

    # 5) Formulaires → Tampons → Cerfas → Formulaires
    link "$ROOT/Administration centrale/Ministère des Papiers/Direction des Formulaires/Tampon nécessaire" \
         "$ROOT/Administration centrale/Hôtel du Roi/Grande Chancellerie/Bureau des Tampons"
    link "$ROOT/Offices/Office des Cerfas/Dépôt" \
         "$ROOT/Administration centrale/Ministère des Papiers/Direction des Formulaires"

    # 6) Labyrinthe de l’Office unique du Tampon
    link "$ROOT/Offices/Office unique du Tampon/Guichet/Orientation" \
         "$ROOT/Offices/Office unique du Tampon/Contre-guichet"
    link "$ROOT/Offices/Office unique du Tampon/Contre-guichet/Formulaire de Retour" \
         "$ROOT/Offices/Office unique du Tampon/Service du Retour"
    link "$ROOT/Offices/Office unique du Tampon/Service du Retour/Retour au début" \
         "$ROOT/Offices/Office unique du Tampon/Guichet"

    # 7) Ponts Académie ↔ Administration
    link "$ROOT/Académie de Géo-mancie/Secrétariat des Études/Bureau des Inscriptions/Validation préfectorale" \
         "$ROOT/Administration centrale/Préfecture du Royaume"
    link "$ROOT/Administration centrale/Ministère des Ponts et Chemins/Bureau des Montages/Stage obligatoire à l'Académie" \
         "$ROOT/Académie de Géo-mancie/Départements/Cartographie Éthérique/Labos"
    link "$ROOT/Administration centrale/Archives/Passerelle vers la Bibliothèque des Cartes Impossibles" \
         "$ROOT/Académie de Géo-mancie/Bibliothèque des Cartes Impossibles/Rez-de-chaussée/Index mouvant"
    link "$ROOT/Académie de Géo-mancie/Institut des Flux et Contre-Flux/Procédure de validation des flux" \
         "$ROOT/Administration centrale/Cour des Comptes et Demi Comptes/Greffe"

    echo "$(eval_gettext "✅ Kingdom of Bordereau VI the Stamped: quirky objects, Academy of Geo-mancy and administrative labyrinths created (without villages).")"
}
