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

    echo "🖋️  Génération du lore du Royaume de Bordereau VI le Tamponné..."
    ROOT="$(eval_gettext "\$GSH_HOME/Royaume")"

    # Château ————————————————————————————————————————————————————————————————
    mkd "$ROOT/Château/Tour principale/Premier étage/Deuxième étage/Sommet de la tour"
    writ "$ROOT/Château/Tour principale/Premier étage/Journal du Concierge.txt" \
    "Jour 34 : quelqu'un a déplacé le sablier des audiences. Le temps est désormais en avance sur lui-même."

    writ "$ROOT/Château/Tour principale/Objets/Tampon royal (bois de licorne).txt" \
    "Usage : apposer. Effet secondaire : respect instantané."

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

    # Gens et papiers (fichiers) ————————————————————————————————————————————
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
    "Abricots (non); Attestations (oui); Avertissements (peut-être). Voir aussi : Zèbres (classés à A par erreur)."

    # Commissions (avec membres) ————————————————————————————————————————————————
    heredoc "$ROOT/Administration centrale/Commissions/Commission 1/Liste des membres.txt" <<'EOF'
    - Dame Pénélope de la Punaise (présidente)
    - Sire Fernand du Parapheur (vice-président)
    - Maître Loris des Liasses (rapporteur)
EOF

    heredoc "$ROOT/Administration centrale/Commissions/Commission 2/Liste des membres.txt" <<'EOF'
    - Capitaine Clotaire du Cachet
    - Demoiselle Agathe du Bordereau
    - Frère Nestor des Annexes
EOF

    heredoc "$ROOT/Administration centrale/Commissions/Commission 3/Liste des membres.txt" <<'EOF'
    - Intendante Salomé de la Signature
    - Greffier Octave de l'Agrafe
    - Sergente Éline de la Reliure
EOF

    # Offices spécialisés ——————————————————————————————————————————————————
    mkd "$ROOT/Offices/Office unique du Tampon/Guichet"
    mkd "$ROOT/Offices/Office unique du Tampon/Contre-guichet"
    mkd "$ROOT/Offices/Office unique du Tampon/Service du Retour"
    mkd "$ROOT/Offices/Office des Cerfas/CERFA 13B"
    mkd "$ROOT/Offices/Office des Cerfas/CERFA 13C"
    mkd "$ROOT/Offices/Office des Plaintes et Demandes de Plaintes"

    writ "$ROOT/Offices/Office des Plaintes et Demandes de Plaintes/Exemple de plainte (modèle).txt" \
    "Objet : plainte contre le formulaire de plainte, trop plaintif."

    writ "$ROOT/Offices/Office unique du Tampon/Guichet/Plaquette d'orientation.txt" \
    "Pour toute question, adressez-vous au Contre-guichet. Pour contester, Service du Retour."

    writ "$ROOT/Offices/Office des Cerfas/CERFA 13B/Notice d'utilisation.txt" \
    "Remplir en bleu. Sauf si vous n'avez pas de bleu, dans ce cas : recommencer en bleu."

    # Bourgs (à la racine, pas de “Villes”) ——————————————————————————————————————
    for B in "Ouskelcoule" "Douskelpar" "Grandflac"; do
    mkd "$ROOT/$B/Mairie/Bureau du Timbre"
    mkd "$ROOT/$B/Perception/Comptoir des Oboles"
    mkd "$ROOT/$B/Garde/Corps de Ronde"

    heredoc "$ROOT/$B/Mairie/Conseil municipal — Procès-verbal.txt" <<EOF
    Séance ouverte à l'heure prévue, à savoir : « après le thé ».
    Décisions :
    - Création d'un passage piéton pour escargots.
    - Adhésion au Programme « Un tampon pour tous ».
EOF

    writ "$ROOT/$B/Perception/Tarifs officiels des Oboles.txt" \
    "1 sourire = 1/2 obole (non remboursable). 1 formulaire perdu = 3 oboles."

    writ "$ROOT/$B/Garde/Tableau de service.txt" \
    "Lundi : ronde en carré. Mardi : ronde en triangle. Mercredi : ronde en rond (classique)."
    done

    # Petits habitants & objets farfelus ————————————————————————————————————————
    writ "$ROOT/Ouskelcoule/Habitants/Marinette du Guichet.txt" \
    "Qualité : trouve la bonne file avant même qu'elle n'existe."

    writ "$ROOT/Ouskelcoule/Objets/Plaque « Priorité au Tampon ».txt" \
    "Panneau officiel. Quiconque lit ceci doit faire la queue."

    writ "$ROOT/Douskelpar/Habitants/Brice de la Pile-à-lire.txt" \
    "Empile jusqu'au plafond ; jure qu'il lira « demain après-midi »."

    writ "$ROOT/Douskelpar/Objets/Cloche de fin d'attente (muette).txt" \
    "Ne sonne jamais, mais rassure tout le monde."

    writ "$ROOT/Grandflac/Habitants/Mireille des Marges.txt" \
    "Règle les marges au millipoil ; voit les alinéas la nuit."

    writ "$ROOT/Grandflac/Objets/Sceau auto-encreur (capricieux).txt" \
    "Fonctionne si on le félicite d'abord."

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
    if [[ -n "${prev}" ]]; then
        link "$base/$prev/Étape suivante" "$base/$s"
    fi
    prev="$s"
    done
    # boucle vers le début
    link "$base/Guichet n°0/Retour au début" "$base/Accueil du Public"

    # Liens absurdes (déjà existants + nouveaux) ——————————————————————————————————
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

    # 7) Boucles dans chaque bourg
    for B in "Ouskelcoule" "Douskelpar" "Grandflac"; do
    link "$ROOT/$B/Mairie/Demande de tampon" \
        "$ROOT/$B/Mairie/Bureau du Timbre"
    link "$ROOT/$B/Mairie/Bureau du Timbre/Validation préfectorale" \
        "$ROOT/Administration centrale/Préfecture du Royaume"
    link "$ROOT/Administration centrale/Préfecture du Royaume/Retour à $B" \
        "$ROOT/$B/Mairie"
    done

    # 8) Archives : index sur lui-même
    link "$ROOT/Administration centrale/Archives/Index général" \
        "$ROOT/Administration centrale/Archives/Rayonnages/A à Z"

    echo "✅ Royaume de Bordereau VI le Tamponné : lieux, gens, objets et labyrinthes administratifs créés."
}