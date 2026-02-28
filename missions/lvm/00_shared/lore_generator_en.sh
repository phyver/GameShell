#!/usr/bin/env bash

# Main lore generation function —————————————————————————————————————————————
generate_lore() {

    # Helpers ————————————————————————————————————————————————————————————————
    mkd() {
        mkdir -p "$1";
    }

    link() {
        local dest="$1";
        local target="$2    # 1) "Unique counter" ↔ "Waitin    # 6) Unique Stamp Office labyrinth
    link "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Unique Stamp Office")/$(eval_gettext "Counter")/$(eval_gettext "Orientation")" \
         "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Unique Stamp Office")/$(eval_gettext "Counter-counter")"
    link "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Unique Stamp Office")/$(eval_gettext "Counter-counter")/$(eval_gettext "Return Form")" \
         "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Unique Stamp Office")/$(eval_gettext "Return Service")"
    link "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Unique Stamp Office")/$(eval_gettext "Return Service")/$(eval_gettext "Return to beginning")" \
         "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Unique Stamp Office")/$(eval_gettext "Counter")"
    link "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Unique counter")" \
         "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "King's Hotel")/$(eval_gettext "Antechamber")/$(eval_gettext "Waiting Room")"
    link "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "King's Hotel")/$(eval_gettext "Antechamber")/$(eval_gettext "Waiting Room")/$(eval_gettext "return to counter")" \
         "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Unique counter")"      mkd "$(dirname "$dest")";
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
    ROOT="$(eval_gettext "\$GSH_HOME/Kingdom")"

    # Castle ————————————————————————————————————————————————————————————————
    mkd "$ROOT/$(eval_gettext "Castle")/$(eval_gettext "Main Tower")/$(eval_gettext "First Floor")/$(eval_gettext "Second Floor")/$(eval_gettext "Tower Summit")"
    mkd "$ROOT/$(eval_gettext "Castle")/$(eval_gettext "Objects")"
    writ "$ROOT/$(eval_gettext "Castle")/$(eval_gettext "Main Tower")/$(eval_gettext "First Floor")/$(eval_gettext "Concierge's Journal.txt")" \
        "$(eval_gettext "Day 34: someone moved the audience hourglass. Time is now ahead of itself.")"
    writ "$ROOT/$(eval_gettext "Castle")/$(eval_gettext "Objects")/$(eval_gettext "Royal Stamp (unicorn wood).txt")" \
        "$(eval_gettext "Usage: affix. Side effect: instant respect.")"
    writ "$ROOT/$(eval_gettext "Castle")/$(eval_gettext "Objects")/$(eval_gettext "Key to the key drawer.txt")" \
        "$(eval_gettext "Only opens keys. For drawers, provide another form.")"
    writ "$ROOT/$(eval_gettext "Castle")/$(eval_gettext "Objects")/$(eval_gettext "Parade Paraph (too heavy to serve).txt")" \
        "$(eval_gettext "Ceremonial object. Appears more official than the law.")"

    writ "$ROOT/$(eval_gettext "Castle")/$(eval_gettext "Official Portraits")/$(eval_gettext "Bordereau VI the Stamped.txt")" \
        "$(eval_gettext "King, lover of clear procedures and opaque stamps. Motto: \"Who stamps reigns.\"")"

    # Central Administration ——————————————————————————————————————————————
    mkd "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "King's Hotel")/$(eval_gettext "Great Chancellery")/$(eval_gettext "Stamps Office")"
    mkd "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "King's Hotel")/$(eval_gettext "Antechamber")/$(eval_gettext "Waiting Room")"
    mkd "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Ministry of Papers")/$(eval_gettext "Forms Directorate")"
    mkd "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Ministry of Papers")/$(eval_gettext "Duplicate Service")"
    mkd "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Ministry of Bridges and Roads")/$(eval_gettext "Mounting Office")"
    mkd "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Ministry of Rumors")/$(eval_gettext "Whispers Cabinet")"
    mkd "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Court of Accounts and Half Accounts")/$(eval_gettext "Registry")"
    mkd "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Kingdom Prefecture")/$(eval_gettext "Counter A-M")"
    mkd "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Kingdom Prefecture")/$(eval_gettext "Counter N-Z")"
    mkd "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Archives")/$(eval_gettext "Shelving")/$(eval_gettext "A to Z")"
    mkd "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Commissions")/$(eval_gettext "Commission 1")"
    mkd "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Commissions")/$(eval_gettext "Commission 2")"
    mkd "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Commissions")/$(eval_gettext "Commission 3")"

    # Regulations, circulars and whispers ————————————————————————————————————
    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "King's Hotel")/$(eval_gettext "Antechamber")/$(eval_gettext "Waiting Room")/$(eval_gettext "Number 0001.txt")" \
        "$(eval_gettext "You will be called after number 0000 (when it exists).")"

    heredoc "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "King's Hotel")/$(eval_gettext "Great Chancellery")/$(eval_gettext "Stamps Office")/$(eval_gettext "Internal Regulations.md")" <<'EOF'
# $(eval_gettext "Internal Regulations of the Stamps Office")
1. $(eval_gettext "Any request must be stamped before being submitted to be stamped.")
2. $(eval_gettext "Stamps are not to be stamped, except in case of emergency (form \"URG-URG\").")
3. $(eval_gettext "Employees must soothe the feathered stamp every morning.")
EOF

    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Ministry of Papers")/$(eval_gettext "Forms Directorate")/$(eval_gettext "Circular Procedure n° ∞.md")" \
        "$(eval_gettext "Step 1: consult Step 2. Step 2: consult Step 1. (Stamp required at each consultation.)")"

    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Ministry of Rumors")/$(eval_gettext "Whispers Cabinet")/$(eval_gettext "Whisper of the day.txt")" \
        "$(eval_gettext "They say the pile of files is taller seen from below.")"

    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Court of Accounts and Half Accounts")/$(eval_gettext "Registry")/$(eval_gettext "Half-receipt (to complete).txt")" \
        "$(eval_gettext "Please present the other half to prove the existence of this one.")"

    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Archives")/$(eval_gettext "Shelving")/$(eval_gettext "A to Z")/$(eval_gettext "Index (partial).txt")" \
        "$(eval_gettext "Apricots (no); Certificates (yes); Warnings (maybe). See also: Zebras (filed under A by mistake).")"

    # Bizarre objects distributed in services —————————————————————————————————
    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "King's Hotel")/$(eval_gettext "Antechamber")/$(eval_gettext "Waiting Room")/$(eval_gettext "Plastic plant (badge holder).txt")" \
        "$(eval_gettext "Seniority: 12 years. Acquired rights: priority at the counter.")"
    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "King's Hotel")/$(eval_gettext "Great Chancellery")/$(eval_gettext "Stamps Office")/$(eval_gettext "Quantum stamp.txt")" \
        "$(eval_gettext "Affixes and removes the seal simultaneously until observed by a superior.")"
    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "King's Hotel")/$(eval_gettext "Great Chancellery")/$(eval_gettext "Stamps Office")/$(eval_gettext "Bottomless inkwell.txt")" \
        "$(eval_gettext "Structural deficit. Voted every year by acclamation.")"
    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Ministry of Papers")/$(eval_gettext "Forms Directorate")/$(eval_gettext "Random forms dispenser.txt")" \
        "$(eval_gettext "Spits out a different CERFA with each swear word. Doesn't take change.")"
    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Ministry of Papers")/$(eval_gettext "Duplicate Service")/$(eval_gettext "Photocopy of an unfindable original copy.txt")" \
        "$(eval_gettext "Authenticated by the absence of the original.")"
    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Ministry of Bridges and Roads")/$(eval_gettext "Mounting Office")/$(eval_gettext "Vertical bubble level.txt")" \
        "$(eval_gettext "Indicates the moral inclination of the project.")"
    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Ministry of Rumors")/$(eval_gettext "Whispers Cabinet")/$(eval_gettext "Whispering microphone.txt")" \
        "$(eval_gettext "Repeats \"apparently\" with authority.")"
    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Court of Accounts and Half Accounts")/$(eval_gettext "Registry")/$(eval_gettext "Digital abacus (unplugged).txt")" \
        "$(eval_gettext "Optimizes invisible savings.")"
    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Kingdom Prefecture")/$(eval_gettext "Counter A-M")/$(eval_gettext "Ticket regurgitator automaton.txt")" \
        "$(eval_gettext "Returns a ticket older than yours.")"
    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Kingdom Prefecture")/$(eval_gettext "Counter N-Z")/$(eval_gettext "Queue line snake rope.txt")" \
        "$(eval_gettext "Lengthens as soon as you think you're reaching the goal.")"
    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Archives")/$(eval_gettext "Shelving")/$(eval_gettext "A to Z")/$(eval_gettext "Schrödinger's file (filed and lost).txt")" \
        "$(eval_gettext "Exists as long as no one consults it.")"

    # Commissions (with members + objects) ——————————————————————————————————————
    heredoc "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Commissions")/$(eval_gettext "Commission 1")/$(eval_gettext "Member list.txt")" <<'EOF'
- $(eval_gettext "Dame Pénélope de la Punaise (president)")
- $(eval_gettext "Sire Fernand du Parapheur (vice-president)")
- $(eval_gettext "Master Loris des Liasses (rapporteur)")
EOF
    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Commissions")/$(eval_gettext "Commission 1")/$(eval_gettext "Session bell (mute).txt")" \
        "$(eval_gettext "Signals the end of debate as soon as it begins.")"

    heredoc "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Commissions")/$(eval_gettext "Commission 2")/$(eval_gettext "Member list.txt")" <<'EOF'
- $(eval_gettext "Captain Clotaire du Cachet")
- $(eval_gettext "Demoiselle Agathe du Bordereau")
- $(eval_gettext "Brother Nestor des Annexes")
EOF
    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Commissions")/$(eval_gettext "Commission 2")/$(eval_gettext "Folding chair (unfolded by decree).txt")" \
        "$(eval_gettext "Only folds to written injunctions.")"

    heredoc "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Commissions")/$(eval_gettext "Commission 3")/$(eval_gettext "Member list.txt")" <<'EOF'
- $(eval_gettext "Stewardess Salomé de la Signature")
- $(eval_gettext "Registrar Octave de l'Agrafe")
- $(eval_gettext "Sergeant Éline de la Reliure")
EOF
    writ "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Commissions")/$(eval_gettext "Commission 3")/$(eval_gettext "Protocol stapler (without staples).txt")" \
        "$(eval_gettext "Brings together without attaching.")"

    # —————————————————————————————————————————————————————————————————————————————
    # ACADEMY OF GEO-MANCY (new section)
    # —————————————————————————————————————————————————————————————————————————————
    mkd "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Study Secretariat")/$(eval_gettext "Registration Office")"
    mkd "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Study Secretariat")/$(eval_gettext "Retake Service")"
    mkd "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Library of Impossible Maps")/$(eval_gettext "Contradictory Atlases Room")"
    mkd "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Library of Impossible Maps")/$(eval_gettext "Ground Floor")/$(eval_gettext "Moving Index")"
    mkd "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Departments")/$(eval_gettext "Etheric Cartography")/$(eval_gettext "Labs")"
    mkd "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Departments")/$(eval_gettext "Stamp Topology")/$(eval_gettext "Labs")"
    mkd "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Departments")/$(eval_gettext "Forms Geology")/$(eval_gettext "Labs")"
    mkd "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Institute of Flows and Counter-Flows")/$(eval_gettext "Amphitheater ∮")"
    mkd "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Observatory of Administrative Lines")/$(eval_gettext "Meridians Terrace")"
    mkd "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Competitions and Aggregations")/$(eval_gettext "Examination Room")"
    mkd "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Tools Museum")/$(eval_gettext "Instruments")"

    # Regulations and presentation
    heredoc "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Study Secretariat")/$(eval_gettext "Student guide.md")" <<'EOF'
# $(eval_gettext "Geo-mantic student guide")
- $(eval_gettext "Cardinal principle: every territory is a matter of paper.")
- $(eval_gettext "ECTS credits mean \"Echelons, Cachets, Tampons, Signatures\".")
- $(eval_gettext "Any valid map must include at least one administrative dead end.")
EOF

    writ "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Study Secretariat")/$(eval_gettext "Registration Office")/$(eval_gettext "Opening hours.txt")" \
        "$(eval_gettext "Open on even working days, except when it's odd.")"

    # Library and objects
    writ "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Library of Impossible Maps")/$(eval_gettext "Contradictory Atlases Room")/$(eval_gettext "Flat atlas of the round Earth.txt")" \
        "$(eval_gettext "Revised edition: now spheri-flat according to decree.")"
    writ "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Library of Impossible Maps")/$(eval_gettext "Ground Floor")/$(eval_gettext "Moving Index")/$(eval_gettext "User manual.txt")" \
        "$(eval_gettext "To find A, look for Z, then return to A via Beta corridor.")"

    # Departments — teachers, courses, objects
    heredoc "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Departments")/$(eval_gettext "Etheric Cartography")/$(eval_gettext "Program.md")" <<'EOF'
## $(eval_gettext "Etheric Cartography — Program")
- $(eval_gettext "Introduction to trace-therapy")
- $(eval_gettext "Variable geometry of moral borders")
- $(eval_gettext "Seminar: The hesitant compass")
EOF
    writ "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Departments")/$(eval_gettext "Etheric Cartography")/$(eval_gettext "Labs")/$(eval_gettext "Indecisive compass.txt")" \
        "$(eval_gettext "Turns until the presence of a department head.")"

    heredoc "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Departments")/$(eval_gettext "Stamp Topology")/$(eval_gettext "Program.md")" <<'EOF'
## $(eval_gettext "Stamp Topology — Program")
- $(eval_gettext "Non-commutative seal groups")
- $(eval_gettext "Homotopy of validation circuits")
- $(eval_gettext "Seminar: Torus of waiting lines")
EOF
    writ "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Departments")/$(eval_gettext "Stamp Topology")/$(eval_gettext "Labs")/$(eval_gettext "Möbius stamp.txt")" \
        "$(eval_gettext "One side, two lines, no exit.")"

    heredoc "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Departments")/$(eval_gettext "Forms Geology")/$(eval_gettext "Program.md")" <<'EOF'
## $(eval_gettext "Forms Geology — Program")
- $(eval_gettext "Stratigraphy of annexes")
- $(eval_gettext "Metamorphism under paraph")
- $(eval_gettext "Seminar: Version fossils")
EOF
    writ "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Departments")/$(eval_gettext "Forms Geology")/$(eval_gettext "Labs")/$(eval_gettext "Stratified section of a file.txt")" \
        "$(eval_gettext "Observe without disturbing the fragile \"missing pieces\" layer.")"

    # Institute of Flows
    writ "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Institute of Flows and Counter-Flows")/$(eval_gettext "Amphitheater ∮")/$(eval_gettext "Self-erasing blackboard.txt")" \
        "$(eval_gettext "Erases demonstrations just before the conclusion.")"

    # Observatory
    writ "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Observatory of Administrative Lines")/$(eval_gettext "Meridians Terrace")/$(eval_gettext "Paperwork telescope.txt")" \
        "$(eval_gettext "Only magnifies illegible signatures.")"

    # Tools Museum
    writ "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Tools Museum")/$(eval_gettext "Instruments")/$(eval_gettext "Deadline drawing board.txt")" \
        "$(eval_gettext "Allows adding a calendar month to any natural delay.")"

    # Competitions — tests, subjects, results
    heredoc "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Competitions and Aggregations")/$(eval_gettext "Examination Room")/$(eval_gettext "Sample subject.md")" <<'EOF'
# $(eval_gettext "Administrative Geo-mancy Aggregation — Sample subject")
1) $(eval_gettext "Map a mobile border between two closed counters.")
2) $(eval_gettext "Demonstrate the existence of a shortcut longer than the official detour.")
3) $(eval_gettext "Stamp the hypothesis, then remove it cleanly.")
EOF
    writ "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Competitions and Aggregations")/$(eval_gettext "Examination Room")/$(eval_gettext "Approved cheat sheet (blank).txt")" \
        "$(eval_gettext "To be filled only inadvertently.")"

    # Specialized offices ——————————————————————————————————————————————————————
    mkd "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Unique Stamp Office")/$(eval_gettext "Counter")"
    mkd "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Unique Stamp Office")/$(eval_gettext "Counter-counter")"
    mkd "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Unique Stamp Office")/$(eval_gettext "Return Service")"
    mkd "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Cerfas Office")/$(eval_gettext "CERFA 13B")"
    mkd "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Cerfas Office")/$(eval_gettext "CERFA 13C")"
    mkd "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Complaints and Complaint Requests Office")"

    writ "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Complaints and Complaint Requests Office")/$(eval_gettext "Example complaint (template).txt")" \
        "$(eval_gettext "Subject: complaint against the complaint form, too complaining.")"
    writ "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Unique Stamp Office")/$(eval_gettext "Counter")/$(eval_gettext "Orientation brochure.txt")" \
        "$(eval_gettext "For any question, address the Counter-counter. To contest: Return Service.")"
    writ "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Cerfas Office")/$(eval_gettext "CERFA 13B")/$(eval_gettext "User manual.txt")" \
        "$(eval_gettext "Fill in blue. Except if you don't have blue, in which case: start over in blue.")"

    # Office objects
    writ "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Unique Stamp Office")/$(eval_gettext "Counter")/$(eval_gettext "Administrative hourglass set to \"in progress\".txt")" \
        "$(eval_gettext "Never empties completely, in accordance with procedure.")"
    writ "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Unique Stamp Office")/$(eval_gettext "Counter-counter")/$(eval_gettext "Conditional ink pen.txt")" \
        "$(eval_gettext "Writes only after the stamp, never before.")"
    writ "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Unique Stamp Office")/$(eval_gettext "Return Service")/$(eval_gettext "Bottomless complaints box.txt")" \
        "$(eval_gettext "All claims find their downfall there.")"
    writ "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Cerfas Office")/$(eval_gettext "CERFA 13C")/$(eval_gettext "Self-referenced form.txt")" \
        "$(eval_gettext "Please attach CERFA 13C to this CERFA 13C.")"
    writ "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Complaints and Complaint Requests Office")/$(eval_gettext "Whispering megaphone.txt")" \
        "$(eval_gettext "Amplifies indignant silences.")"

    # Kafkaesque journey in 10 steps (loop assured) ————————————————————————————
    steps=(
        "$(eval_gettext "Public Reception")"
        "$(eval_gettext "Ticket Distribution")"
        "$(eval_gettext "Provisional Orientation")"
        "$(eval_gettext "Preliminary Pre-validation")"
        "$(eval_gettext "Control Compliance Control")"
        "$(eval_gettext "Internal Prefecture Visa")"
        "$(eval_gettext "Intent Stamping")"
        "$(eval_gettext "Verification Verification")"
        "$(eval_gettext "Penultimate Step Counter-Validation")"
        "$(eval_gettext "Counter No. 0")"
    )
    base="$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Standard Administrative Path")"
    prev=""
    for s in "${steps[@]}"; do
        mkd "$base/$s"
        writ "$base/$s/$(eval_gettext "Instructions.txt")" "$(eval_gettext "Present the document obtained in the previous step.")"
        # Add an absurd object specific to the step
        case "$s" in
            "$(eval_gettext "Public Reception")")
                writ "$base/$s/$(eval_gettext "Motivating ceiling light.txt")" "$(eval_gettext "Displays \"Almost done!\" upon arrival.")"
                ;;
            "$(eval_gettext "Ticket Distribution")")
                writ "$base/$s/$(eval_gettext "Imaginary number ticket.txt")" "$(eval_gettext "Served after the real ones, before the priority ones.")"
                ;;
            "$(eval_gettext "Provisional Orientation")")
                writ "$base/$s/$(eval_gettext "Administrative compass.txt")" "$(eval_gettext "Always points to the opposite counter.")"
                ;;
            "$(eval_gettext "Preliminary Pre-validation")")
                writ "$base/$s/$(eval_gettext "Shadow stamp.txt")" "$(eval_gettext "Leaves an invisible but regulatory trace.")"
                ;;
            "$(eval_gettext "Control Compliance Control")")
                writ "$base/$s/$(eval_gettext "Checklist checklist.txt")" "$(eval_gettext "Last item: check this checklist.")"
                ;;
            "$(eval_gettext "Internal Prefecture Visa")")
                writ "$base/$s/$(eval_gettext "Swinging door (leads nowhere).txt")" "$(eval_gettext "Approved for back-and-forth.")"
                ;;
            "$(eval_gettext "Intent Stamping")")
                writ "$base/$s/$(eval_gettext "Tacit intentions form.txt")" "$(eval_gettext "To be filled without writing anything.")"
                ;;
            "$(eval_gettext "Verification Verification")")
                writ "$base/$s/$(eval_gettext "Protocol magnifying glass.txt")" "$(eval_gettext "Magnifies paperwork, reduces hope.")"
                ;;
            "$(eval_gettext "Penultimate Step Counter-Validation")")
                writ "$base/$s/$(eval_gettext "Contradictory seal.txt")" "$(eval_gettext "Validates and invalidates simultaneously.")"
                ;;
            "$(eval_gettext "Counter No. 0")")
                writ "$base/$s/$(eval_gettext "Impossible bell.txt")" "$(eval_gettext "Ring scheduled for next budget year.")"
                ;;
        esac

        if [[ -n "${prev}" ]]; then
            link "$base/$prev/$(eval_gettext "Next step")" "$base/$s"
        fi
        prev="$s"
    done
    # loop to the beginning
    link "$base/$(eval_gettext "Counter No. 0")/$(eval_gettext "Return to beginning")" "$base/$(eval_gettext "Public Reception")"

    # Absurd inter-service links ————————————————————————————————————————————
    # 1) “Guichet unique” ↔ “Salle d'attente”
    link "$ROOT/Administration centrale/Guichet unique" \
         "$ROOT/Administration centrale/Hôtel du Roi/Antichambre/Salle d'attente"
    link "$ROOT/Administration centrale/Hôtel du Roi/Antichambre/Salle d'attente/retour au guichet" \
         "$ROOT/Administration centrale/Guichet unique"

    # 2) Stamps Office ↔ Duplicate Service
    link "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "King's Hotel")/$(eval_gettext "Great Chancellery")/$(eval_gettext "Stamps Office")/$(eval_gettext "Duplicate requests")" \
         "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Ministry of Papers")/$(eval_gettext "Duplicate Service")"
    link "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Ministry of Papers")/$(eval_gettext "Duplicate Service")/$(eval_gettext "Final validation")" \
         "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "King's Hotel")/$(eval_gettext "Great Chancellery")/$(eval_gettext "Stamps Office")"

    # 3) Prefecture: A-M ↔ N-Z
    link "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Kingdom Prefecture")/$(eval_gettext "Counter A-M")/$(eval_gettext "next counter")" \
         "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Kingdom Prefecture")/$(eval_gettext "Counter N-Z")"
    link "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Kingdom Prefecture")/$(eval_gettext "Counter N-Z")/$(eval_gettext "referral")" \
         "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Kingdom Prefecture")/$(eval_gettext "Counter A-M")"

    # 4) Commissions in circle
    link "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Commissions")/$(eval_gettext "Commission 1")/$(eval_gettext "transmission")" \
         "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Commissions")/$(eval_gettext "Commission 2")"
    link "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Commissions")/$(eval_gettext "Commission 2")/$(eval_gettext "transmission")" \
         "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Commissions")/$(eval_gettext "Commission 3")"
    link "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Commissions")/$(eval_gettext "Commission 3")/$(eval_gettext "transmission")" \
         "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Commissions")/$(eval_gettext "Commission 1")"

    # 5) Forms → Stamps → Cerfas → Forms
    link "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Ministry of Papers")/$(eval_gettext "Forms Directorate")/$(eval_gettext "Stamp required")" \
         "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "King's Hotel")/$(eval_gettext "Great Chancellery")/$(eval_gettext "Stamps Office")"
    link "$ROOT/$(eval_gettext "Offices")/$(eval_gettext "Cerfas Office")/$(eval_gettext "Deposit")" \
         "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Ministry of Papers")/$(eval_gettext "Forms Directorate")"

    # 6) Labyrinthe de l’Office unique du Tampon
    link "$ROOT/Offices/Office unique du Tampon/Guichet/Orientation" \
         "$ROOT/Offices/Office unique du Tampon/Contre-guichet"
    link "$ROOT/Offices/Office unique du Tampon/Contre-guichet/Formulaire de Retour" \
         "$ROOT/Offices/Office unique du Tampon/Service du Retour"
    link "$ROOT/Offices/Office unique du Tampon/Service du Retour/Retour au début" \
         "$ROOT/Offices/Office unique du Tampon/Guichet"

    # 7) Academy ↔ Administration bridges
    link "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Study Secretariat")/$(eval_gettext "Registration Office")/$(eval_gettext "Prefecture validation")" \
         "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Kingdom Prefecture")"
    link "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Ministry of Bridges and Roads")/$(eval_gettext "Mounting Office")/$(eval_gettext "Mandatory Academy internship")" \
         "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Departments")/$(eval_gettext "Etheric Cartography")/$(eval_gettext "Labs")"
    link "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Archives")/$(eval_gettext "Bridge to the Library of Impossible Maps")" \
         "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Library of Impossible Maps")/$(eval_gettext "Ground Floor")/$(eval_gettext "Moving Index")"
    link "$ROOT/$(eval_gettext "Academy of Geo-mancy")/$(eval_gettext "Institute of Flows and Counter-Flows")/$(eval_gettext "Flow validation procedure")" \
         "$ROOT/$(eval_gettext "Central Administration")/$(eval_gettext "Court of Accounts and Half Accounts")/$(eval_gettext "Registry")"

    echo "$(eval_gettext "✅ Kingdom of Bordereau VI the Stamped: bizarre objects, Academy of Geo-mancy and administrative labyrinths created (without villages).")"
}
