#!/usr/bin/env sh

# Make mount points
mkdir -p "$GSH_HOME/USA/Douskelpar"
mkdir -p "$GSH_HOME/USA/Ouskelcoule"
mkdir -p "$GSH_HOME/USA/Grandflac"


# Import USA VG
danger sudo vgimport -y usa
danger sudo vgchange -ay usa

# Mount the filesystems
danger sudo mount /dev/usa/douskelpar "$GSH_HOME/USA/Douskelpar"
danger sudo chown -R "$USER:$USER" "$GSH_HOME/USA/Douskelpar"
danger sudo mount /dev/usa/ouskelcoule "$GSH_HOME/USA/Ouskelcoule"
danger sudo chown -R "$USER:$USER" "$GSH_HOME/USA/Ouskelcoule"
danger sudo mount /dev/usa/grandflac "$GSH_HOME/USA/Grandflac"
danger sudo chown -R "$USER:$USER" "$GSH_HOME/USA/Grandflac"

