cd "$(find ~/Chateau/Cave -name "labyrinthe" -type d)"
find . -name "*piece*" -type f -print0 | xargs -0 mv -t ~/Foret/Cabane/Coffre
gash check
