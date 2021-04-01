cd "$(find ~/Chateau/Cave -name "labyrinthe" -type d)"
find . -iname "*piece*" -type f -print0 | xargs -0 mv -t ~/Foret/Cabane/Coffre
gash check
