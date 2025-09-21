#!/usr/bin/env sh

# Fix filesystem
danger sudo fsck -y /dev/esdea/douskelpar

# Remount the filesystem
danger sudo mount /dev/esdea/douskelpar "$GSH_HOME/Esdea/Douskelpar"
danger sudo chown "$USER:$USER" "$GSH_HOME/Esdea/Douskelpar"
