#!/usr/bin/env sh

mkdir -p "$GSH_HOME/Esdea/Ouskelcoule"
mkdir -p "$GSH_HOME/Esdea/Douskelpar"
mkdir -p "$GSH_HOME/Esdebe/Grandflac"

danger sudo mount /dev/esdea/ouskelcoule "$GSH_HOME/Esdea/Ouskelcoule"
danger sudo chown -R "$USER:$USER" "$GSH_HOME/Esdea/Ouskelcoule"

danger sudo mount /dev/esdea/douskelpar "$GSH_HOME/Esdea/Douskelpar"
danger sudo chown -R "$USER:$USER" "$GSH_HOME/Esdea/Douskelpar"

danger sudo mount /dev/esdebe/grandflac "$GSH_HOME/Esdebe/Grandflac"
danger sudo chown -R "$USER:$USER" "$GSH_HOME/Esdebe/Grandflac"

mkdir -p "$GSH_HOME/Esdea/Ouskelcoule/Maison Commune"
mkdir -p "$GSH_HOME/Esdea/Douskelpar/Maison Commune"
mkdir -p "$GSH_HOME/Esdebe/Grandflac/Maison Commune"

echo "40" > "$GSH_HOME/Esdea/Ouskelcoule/Maison Commune/population.txt"
echo "20" > "$GSH_HOME/Esdea/Douskelpar/Maison Commune/population.txt"
echo "50" > "$GSH_HOME/Esdebe/Grandflac/Maison Commune/population.txt"