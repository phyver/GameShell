#!/usr/bin/env bash
set -e

# Base du monde (compatible avec GSH_HOME si défini)
if [[ -n "$GSH_HOME" ]]; then
  BASE="$GSH_HOME"
else
  BASE="/var/www/html/GameShell/World"
fi

# Colonies par village
declare -A colonies=(
  ["Ouskelcoule"]="Esdea"
  ["Douskelpar"]="Esdea"
  ["Grandflac"]="Esdebe"
)

# --- Fonction utilitaire pour écrire (et créer le dossier parent si besoin)
w() { mkdir -p "$(dirname "$1")"; echo "$2" > "$1"; }

for v in "Ouskelcoule" "Douskelpar" "Grandflac"; do
  V="$BASE/${colonies[$v]}/$v"

  # Maison Commune (population.txt supposé déjà présent)
  mkdir -p "$V/Maison Commune"
  w "$V/Maison Commune/habitant_bailli.txt"      "$(eval_gettext "Bailiff of \$v")"
  w "$V/Maison Commune/habitant_scribe.txt"      "$(eval_gettext "Communal scribe")"
  w "$V/Maison Commune/habitant_garde.txt"       "$(eval_gettext "Rural guard")"
  w "$V/Maison Commune/registre_proprietes.txt"  "$(eval_gettext "See buildings below")"
  w "$V/Maison Commune/registre_decisions.txt"   "$(eval_gettext "Friday = fish day; Quota 1000 Ko in the Common Granary")"

  case "$v" in
    # ================= OUSKELCOULE =================
    Ouskelcoule)
      # 1) Port de pêche
      w "$V/Port De Peche/habitant_maitre_pecheur.txt" "$(eval_gettext "Arsène the master fisherman")"
      w "$V/Port De Peche/barque.txt"                  "$(eval_gettext "Flat-bottomed boat")"
      w "$V/Port De Peche/caisses.txt"                 "$(eval_gettext "Fish crates (strong smell)")"
      # 2) Fumoir
      w "$V/Fumoir/habitant_fumeuse.txt"               "$(eval_gettext "Ysée the smoker")"
      w "$V/Fumoir/bois_a_fumer.txt"                   "$(eval_gettext "Birch bundles")"
      w "$V/Fumoir/poisson_fume.txt"                   "$(eval_gettext "Lots of smoked herring")"
      # 3) Atelier de Filets
      w "$V/Atelier De Filets/habitant_filetier.txt"   "$(eval_gettext "Gaston the net maker")"
      w "$V/Atelier De Filets/aiguille_a_filet.txt"    "$(eval_gettext "Large bone needle")"
      w "$V/Atelier De Filets/chutes_de_corde.txt"     "$(eval_gettext "Hemp scraps")"
      # 4) Chantier Naval
      w "$V/Chantier Naval/habitant_calfat.txt"        "$(eval_gettext "Basile the caulker")"
      w "$V/Chantier Naval/rabot.txt"                  "$(eval_gettext "Well-sharpened plane")"
      w "$V/Chantier Naval/coque_en_cours.txt"         "$(eval_gettext "Hull #12 under construction")"
      # 5) Marché aux Poissons
      w "$V/Marche Aux Poissons/habitant_crieuse.txt"  "$(eval_gettext "Marthe the crier")"
      w "$V/Marche Aux Poissons/étals.txt"             "$(eval_gettext "Damp wooden stalls")"
      w "$V/Marche Aux Poissons/ardoises_prix.txt"     "$(eval_gettext "Daily prices in Kroutons")"
      # 6) Grenier Banal
      w "$V/Grenier Banal/habitant_gardien.txt"        "$(eval_gettext "Prudent the guardian")"
      w "$V/Grenier Banal/stock_poissons.txt"          "$(eval_gettext "0 Ko (quota 1000 Ko)")"
      w "$V/Grenier Banal/cachets_officiels.txt"       "$(eval_gettext "Seals of the Royal Canteen Administration")"
      ;;
    # ================= DOUSKELPAR =================
    Douskelpar)
      # 1) Scierie
      w "$V/Scierie/habitant_scieur.txt"               "$(eval_gettext "Milo the sawyer")"
      w "$V/Scierie/troncs.txt"                        "$(eval_gettext "Stacked logs")"
      w "$V/Scierie/scie_ruban.txt"                    "$(eval_gettext "Large band saw")"
      # 2) Dépôt de Bois
      w "$V/Depot De Bois/habitant_garde_depot.txt"    "$(eval_gettext "Radegonde the guard")"
      w "$V/Depot De Bois/inventaire.txt"              "$(eval_gettext "2m planks, rafters, beams")"
      w "$V/Depot De Bois/chariots.txt"                "$(eval_gettext "Two hand carts")"
      # 3) Atelier Charpente
      w "$V/Atelier Charpente/habitant_charpentier.txt" "$(eval_gettext "Hugo the carpenter")"
      w "$V/Atelier Charpente/tenons_mortaises.txt"     "$(eval_gettext "Set of templates")"
      w "$V/Atelier Charpente/bois_selectionne.txt"     "$(eval_gettext "Straight-grained oak")"
      # 4) Bureau du Mesurage
      w "$V/Bureau Du Mesurage/habitant_mesureur.txt"  "$(eval_gettext "Isaac the measurer")"
      w "$V/Bureau Du Mesurage/jauges.txt"             "$(eval_gettext "Graduated rods")"
      w "$V/Bureau Du Mesurage/registres_bois.txt"     "$(eval_gettext "Register of cut volumes")"
      # 5) Port Fluvial
      w "$V/Port Fluvial/habitant_batelier.txt"        "$(eval_gettext "Noé the boatman")"
      w "$V/Port Fluvial/cornes_de_brouillard.txt"     "$(eval_gettext "Two polished horns")"
      w "$V/Port Fluvial/amarrages.txt"                "$(eval_gettext "Tarred ropes")"
      # 6) Cantine des Bûcherons
      w "$V/Cantine Des Bucherons/habitant_cuisinier.txt" "$(eval_gettext "Thibaut the cook")"
      w "$V/Cantine Des Bucherons/menu_du_jour.txt"       "$(eval_gettext "Beef stew, barley soup")"
      w "$V/Cantine Des Bucherons/banquettes.txt"         "$(eval_gettext "Heavy wooden benches")"
      ;;
    # ================= GRANDFLAC =================
    Grandflac)
      # 1) Moulin
      w "$V/Moulin/habitant_meuniere.txt"              "$(eval_gettext "Jeanne the miller")"
      w "$V/Moulin/meule.txt"                          "$(eval_gettext "Large stone millstone")"
      w "$V/Moulin/courroie.txt"                       "$(eval_gettext "Leather belt")"
      # 2) Bief
      w "$V/Bief/habitant_eclusier.txt"                "$(eval_gettext "Arnaud the lock keeper")"
      w "$V/Bief/vannes.txt"                           "$(eval_gettext "Oak sluice gates")"
      w "$V/Bief/niveau_eau.txt"                       "$(eval_gettext "Stable water level")"
      # 3) Grange à Grains
      w "$V/Grange A Grains/habitant_magasinier.txt"   "$(eval_gettext "Pélagie the storekeeper")"
      w "$V/Grange A Grains/sacs_farine.txt"           "$(eval_gettext "Bags of flour (sealed)")"
      w "$V/Grange A Grains/palans.txt"                "$(eval_gettext "Chain hoists")"
      # 4) Pont à Péage
      w "$V/Pont A Peage/habitant_ponctier.txt"        "$(eval_gettext "Boniface le ponctier")"
      # 4) Pont à Péage
      w "$V/Pont A Peage/habitant_ponctier.txt"        "$(eval_gettext "Boniface the toll keeper")"
      w "$V/Pont A Peage/tarifs.txt"                   "$(eval_gettext "Rates per cart")"
      w "$V/Pont A Peage/caisse_peage.txt"             "$(eval_gettext "Sealed chest")"
      # 5) Atelier de Meunerie
      w "$V/Atelier De Meunerie/habitant_ajusteur.txt" "$(eval_gettext "Odon the adjuster")"
      w "$V/Atelier De Meunerie/jeux_de_cales.txt"     "$(eval_gettext "Wedges and fine wedges")"
      w "$V/Atelier De Meunerie/graisse.txt"           "$(eval_gettext "Pot of grease")"
      # 6) Entrepôt de Farine
      w "$V/Entrepot De Farine/habitant_gardienne.txt" "$(eval_gettext "Agnès the guardian")"
      w "$V/Entrepot De Farine/livre_sorties.txt"      "$(eval_gettext "Daily releases")"
      w "$V/Entrepot De Farine/tamis.txt"              "$(eval_gettext "Spare sieves")"
      ;;
  esac
done

echo "$(eval_gettext "✅ Buildings, people and objects created for Ouskelcoule, Douskelpar and Grandflac.")"
