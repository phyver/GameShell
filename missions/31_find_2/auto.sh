cd "$(find ~/Chateau/Cave -name "labyrinthe" -type d)"
find -type f | xargs grep -l "rubis" |  xargs mv -t ~/Foret/Cabane/Coffre
