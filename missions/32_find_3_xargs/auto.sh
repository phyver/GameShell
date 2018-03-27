cd "$(find ~/Chateau/Cave -name "labyrinthe" -type d)"
find -type f -print0 | xargs -0 grep -l "diamant" |  xargs mv -t ~/Foret/Cabane/Coffre
