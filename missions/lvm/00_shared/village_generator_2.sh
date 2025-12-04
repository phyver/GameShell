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
  w "$V/Maison Commune/habitant_bailli.txt"      "$(eval_gettext "Bailli de \$v")"
  w "$V/Maison Commune/habitant_scribe.txt"      "$(eval_gettext "Scribe communal")"
  w "$V/Maison Commune/habitant_garde.txt"       "$(eval_gettext "Garde champêtre")"
  w "$V/Maison Commune/registre_proprietes.txt"  "$(eval_gettext "Voir bâtiments ci-dessous")"
  w "$V/Maison Commune/registre_decisions.txt"   "$(eval_gettext "Vendredi = jour du poisson ; Quota 1000 Ko au Grenier Banal")"

  case "$v" in
    # ================= OUSKELCOULE =================
    Ouskelcoule)
      # 1) Port de pêche
      w "$V/Port De Peche/habitant_maitre_pecheur.txt" "$(eval_gettext "Arsène le maître pêcheur")"
      w "$V/Port De Peche/barque.txt"                  "$(eval_gettext "Barque à fond plat")"
      w "$V/Port De Peche/caisses.txt"                 "$(eval_gettext "Caisses de poissons (odeur forte)")"
      # 2) Fumoir
      w "$V/Fumoir/habitant_fumeuse.txt"               "$(eval_gettext "Ysée la fumeuse")"
      w "$V/Fumoir/bois_a_fumer.txt"                   "$(eval_gettext "Fagots de bouleau")"
      w "$V/Fumoir/poisson_fume.txt"                   "$(eval_gettext "Lots de hareng fumé")"
      # 3) Atelier de Filets
      w "$V/Atelier De Filets/habitant_filetier.txt"   "$(eval_gettext "Gaston le filetier")"
      w "$V/Atelier De Filets/aiguille_a_filet.txt"    "$(eval_gettext "Grande aiguille en os")"
      w "$V/Atelier De Filets/chutes_de_corde.txt"     "$(eval_gettext "Chutes de chanvre")"
      # 4) Chantier Naval
      w "$V/Chantier Naval/habitant_calfat.txt"        "$(eval_gettext "Basile le calfat")"
      w "$V/Chantier Naval/rabot.txt"                  "$(eval_gettext "Rabot bien aiguisé")"
      w "$V/Chantier Naval/coque_en_cours.txt"         "$(eval_gettext "Coque n°12 en montage")"
      # 5) Marché aux Poissons
      w "$V/Marche Aux Poissons/habitant_crieuse.txt"  "$(eval_gettext "Marthe la crieuse")"
      w "$V/Marche Aux Poissons/étals.txt"             "$(eval_gettext "Étals en bois humide")"
      w "$V/Marche Aux Poissons/ardoises_prix.txt"     "$(eval_gettext "Prix du jour en Kroutons")"
      # 6) Grenier Banal
      w "$V/Grenier Banal/habitant_gardien.txt"        "$(eval_gettext "Prudent le gardien")"
      w "$V/Grenier Banal/stock_poissons.txt"          "$(eval_gettext "0 Ko (quota 1000 Ko)")"
      w "$V/Grenier Banal/cachets_officiels.txt"       "$(eval_gettext "Sceaux de l'Administration des Cantines Royales")"
      ;;
    # ================= DOUSKELPAR =================
    Douskelpar)
      # 1) Scierie
      w "$V/Scierie/habitant_scieur.txt"               "$(eval_gettext "Milo le scieur")"
      w "$V/Scierie/troncs.txt"                        "$(eval_gettext "Troncs empilés")"
      w "$V/Scierie/scie_ruban.txt"                    "$(eval_gettext "Grande scie à ruban")"
      # 2) Dépôt de Bois
      w "$V/Depot De Bois/habitant_garde_depot.txt"    "$(eval_gettext "Radegonde la garde")"
      w "$V/Depot De Bois/inventaire.txt"              "$(eval_gettext "Planches 2m, chevrons, poutres")"
      w "$V/Depot De Bois/chariots.txt"                "$(eval_gettext "Deux chariots à bras")"
      # 3) Atelier Charpente
      w "$V/Atelier Charpente/habitant_charpentier.txt" "$(eval_gettext "Hugo le charpentier")"
      w "$V/Atelier Charpente/tenons_mortaises.txt"     "$(eval_gettext "Jeu de gabarits")"
      w "$V/Atelier Charpente/bois_selectionne.txt"     "$(eval_gettext "Chêne droit fil")"
      # 4) Bureau du Mesurage
      w "$V/Bureau Du Mesurage/habitant_mesureur.txt"  "$(eval_gettext "Isaac le mesureur")"
      w "$V/Bureau Du Mesurage/jauges.txt"             "$(eval_gettext "Baguettes graduées")"
      w "$V/Bureau Du Mesurage/registres_bois.txt"     "$(eval_gettext "Registre des volumes débités")"
      # 5) Port Fluvial
      w "$V/Port Fluvial/habitant_batelier.txt"        "$(eval_gettext "Noé le batelier")"
      w "$V/Port Fluvial/cornes_de_brouillard.txt"     "$(eval_gettext "Deux cornes polies")"
      w "$V/Port Fluvial/amarrages.txt"                "$(eval_gettext "Cordages goudronnés")"
      # 6) Cantine des Bûcherons
      w "$V/Cantine Des Bucherons/habitant_cuisinier.txt" "$(eval_gettext "Thibaut le cuisinier")"
      w "$V/Cantine Des Bucherons/menu_du_jour.txt"       "$(eval_gettext "Ragoût de bœuf, soupe d'orge")"
      w "$V/Cantine Des Bucherons/banquettes.txt"         "$(eval_gettext "Bancs lourds en bois")"
      ;;
    # ================= GRANDFLAC =================
    Grandflac)
      # 1) Moulin
      w "$V/Moulin/habitant_meuniere.txt"              "$(eval_gettext "Jeanne la meunière")"
      w "$V/Moulin/meule.txt"                          "$(eval_gettext "Grande meule de pierre")"
      w "$V/Moulin/courroie.txt"                       "$(eval_gettext "Courroie en cuir")"
      # 2) Bief
      w "$V/Bief/habitant_eclusier.txt"                "$(eval_gettext "Arnaud l'éclusier")"
      w "$V/Bief/vannes.txt"                           "$(eval_gettext "Vannes en chêne")"
      w "$V/Bief/niveau_eau.txt"                       "$(eval_gettext "Hauteur stable")"
      # 3) Grange à Grains
      w "$V/Grange A Grains/habitant_magasinier.txt"   "$(eval_gettext "Pélagie la magasinière")"
      w "$V/Grange A Grains/sacs_farine.txt"           "$(eval_gettext "Sacs de farine (scellés)")"
      w "$V/Grange A Grains/palans.txt"                "$(eval_gettext "Palans à chaîne")"
      # 4) Pont à Péage
      w "$V/Pont A Peage/habitant_ponctier.txt"        "$(eval_gettext "Boniface le ponctier")"
      w "$V/Pont A Peage/tarifs.txt"                   "$(eval_gettext "Tarifs par charrette")"
      w "$V/Pont A Peage/caisse_peage.txt"             "$(eval_gettext "Coffre scellé")"
      # 5) Atelier de Meunerie
      w "$V/Atelier De Meunerie/habitant_ajusteur.txt" "$(eval_gettext "Odon l'ajusteur")"
      w "$V/Atelier De Meunerie/jeux_de_cales.txt"     "$(eval_gettext "Cales et cales fines")"
      w "$V/Atelier De Meunerie/graisse.txt"           "$(eval_gettext "Pot de graisse")"
      # 6) Entrepôt de Farine
      w "$V/Entrepot De Farine/habitant_gardienne.txt" "$(eval_gettext "Agnès la gardienne")"
      w "$V/Entrepot De Farine/livre_sorties.txt"      "$(eval_gettext "Sorties quotidiennes")"
      w "$V/Entrepot De Farine/tamis.txt"              "$(eval_gettext "Tamis de rechange")"
      ;;
  esac
done

echo "$(eval_gettext "✅ Bâtiments, personnes et objets créés pour Ouskelcoule, Douskelpar et Grandflac.")"
