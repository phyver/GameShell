#!/usr/bin/env sh

# This file is not required. When it exists, it is used to automatically
# validate the mission. It should end with a succesful `gsh check` command.
# It is sometimes possible to "cheat" by using any hidden data in $GSH_TMP,
# but it is better to do it the "intended" way.
# If you write this file, rename it to auto.sh

cd Castle/Portals
git clone $MISSION_DIR/al_far_repo al_far
cd al_far
git checkout main
git remote rename origin local
git remote add origin https://github.com/mathaefele/al_far.git
cd ..
gsh check

