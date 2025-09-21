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
  w "$V/Maison Commune/habitant_bailli.txt"      "Bailli de $v"
  w "$V/Maison Commune/habitant_scribe.txt"      "Scribe communal"
  w "$V/Maison Commune/habitant_garde.txt"       "Garde champêtre"
  w "$V/Maison Commune/registre_proprietes.txt"  "Voir bâtiments ci-dessous"
  w "$V/Maison Commune/registre_decisions.txt"   "Vendredi = jour du poisson ; Quota 1000 Ko au Grenier Banal"

  case "$v" in
    # ================= OUSKELCOULE =================
    Ouskelcoule)
      # 1) Port de pêche
      w "$V/Port De Peche/habitant_maitre_pecheur.txt" "Arsène le maître pêcheur"
      w "$V/Port De Peche/barque.txt"                  "Barque à fond plat"
      w "$V/Port De Peche/caisses.txt"                 "Caisses de poissons (odeur forte)"
      # 2) Fumoir
      w "$V/Fumoir/habitant_fumeuse.txt"               "Ysée la fumeuse"
      w "$V/Fumoir/bois_a_fumer.txt"                   "Fagots de bouleau"
      w "$V/Fumoir/poisson_fume.txt"                   "Lots de hareng fumé"
      # 3) Atelier de Filets
      w "$V/Atelier De Filets/habitant_filetier.txt"   "Gaston le filetier"
      w "$V/Atelier De Filets/aiguille_a_filet.txt"    "Grande aiguille en os"
      w "$V/Atelier De Filets/chutes_de_corde.txt"     "Chutes de chanvre"
      # 4) Chantier Naval
      w "$V/Chantier Naval/habitant_calfat.txt"        "Basile le calfat"
      w "$V/Chantier Naval/rabot.txt"                  "Rabot bien aiguisé"
      w "$V/Chantier Naval/coque_en_cours.txt"         "Coque n°12 en montage"
      # 5) Marché aux Poissons
      w "$V/Marche Aux Poissons/habitant_crieuse.txt"  "Marthe la crieuse"
      w "$V/Marche Aux Poissons/étals.txt"             "Étals en bois humide"
      w "$V/Marche Aux Poissons/ardoises_prix.txt"     "Prix du jour en Kroutons"
      # 6) Grenier Banal
      w "$V/Grenier Banal/habitant_gardien.txt"        "Prudent le gardien"
      w "$V/Grenier Banal/stock_poissons.txt"          "0 Ko (quota 1000 Ko)"
      w "$V/Grenier Banal/cachets_officiels.txt"       "Sceaux de l'Administration des Cantines Royales"
      ;;
    # ================= DOUSKELPAR =================
    Douskelpar)
      # 1) Scierie
      w "$V/Scierie/habitant_scieur.txt"               "Milo le scieur"
      w "$V/Scierie/troncs.txt"                        "Troncs empilés"
      w "$V/Scierie/scie_ruban.txt"                    "Grande scie à ruban"
      # 2) Dépôt de Bois
      w "$V/Depot De Bois/habitant_garde_depot.txt"    "Radegonde la garde"
      w "$V/Depot De Bois/inventaire.txt"              "Planches 2m, chevrons, poutres"
      w "$V/Depot De Bois/chariots.txt"                "Deux chariots à bras"
      # 3) Atelier Charpente
      w "$V/Atelier Charpente/habitant_charpentier.txt" "Hugo le charpentier"
      w "$V/Atelier Charpente/tenons_mortaises.txt"     "Jeu de gabarits"
      w "$V/Atelier Charpente/bois_selectionne.txt"     "Chêne droit fil"
      # 4) Bureau du Mesurage
      w "$V/Bureau Du Mesurage/habitant_mesureur.txt"  "Isaac le mesureur"
      w "$V/Bureau Du Mesurage/jauges.txt"             "Baguettes graduées"
      w "$V/Bureau Du Mesurage/registres_bois.txt"     "Registre des volumes débités"
      # 5) Port Fluvial
      w "$V/Port Fluvial/habitant_batelier.txt"        "Noé le batelier"
      w "$V/Port Fluvial/cornes_de_brouillard.txt"     "Deux cornes polies"
      w "$V/Port Fluvial/amarrages.txt"                "Cordages goudronnés"
      # 6) Cantine des Bûcherons
      w "$V/Cantine Des Bucherons/habitant_cuisinier.txt" "Thibaut le cuisinier"
      w "$V/Cantine Des Bucherons/menu_du_jour.txt"       "Ragoût de bœuf, soupe d’orge"
      w "$V/Cantine Des Bucherons/banquettes.txt"         "Bancs lourds en bois"
      ;;
    # ================= GRANDFLAC =================
    Grandflac)
      # 1) Moulin
      w "$V/Moulin/habitant_meuniere.txt"              "Jeanne la meunière"
      w "$V/Moulin/meule.txt"                          "Grande meule de pierre"
      w "$V/Moulin/courroie.txt"                       "Courroie en cuir"
      # 2) Bief
      w "$V/Bief/habitant_eclusier.txt"                "Arnaud l’éclusier"
      w "$V/Bief/vannes.txt"                           "Vannes en chêne"
      w "$V/Bief/niveau_eau.txt"                       "Hauteur stable"
      # 3) Grange à Grains
      w "$V/Grange A Grains/habitant_magasinier.txt"   "Pélagie la magasinière"
      w "$V/Grange A Grains/sacs_farine.txt"           "Sacs de farine (scellés)"
      w "$V/Grange A Grains/palans.txt"                "Palans à chaîne"
      # 4) Pont à Péage
      w "$V/Pont A Peage/habitant_ponctier.txt"        "Boniface le ponctier"
      w "$V/Pont A Peage/tarifs.txt"                   "Tarifs par charrette"
      w "$V/Pont A Peage/caisse_peage.txt"             "Coffre scellé"
      # 5) Atelier de Meunerie
      w "$V/Atelier De Meunerie/habitant_ajusteur.txt" "Odon l’ajusteur"
      w "$V/Atelier De Meunerie/jeux_de_cales.txt"     "Cales et cales fines"
      w "$V/Atelier De Meunerie/graisse.txt"           "Pot de graisse"
      # 6) Entrepôt de Farine
      w "$V/Entrepot De Farine/habitant_gardienne.txt" "Agnès la gardienne"
      w "$V/Entrepot De Farine/livre_sorties.txt"      "Sorties quotidiennes"
      w "$V/Entrepot De Farine/tamis.txt"              "Tamis de rechange"
      ;;
  esac
done

echo "✅ Bâtiments, personnes et objets créés pour Ouskelcoule, Douskelpar et Grandflac."
