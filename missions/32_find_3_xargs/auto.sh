cd "$(find ~/Chateau/Cave -name "labyrinthe" -type d)"
find . -type f -print0 | xargs -0 grep -Zl "diamant" |  xargs -0 mv -t ~/Foret/Cabane/Coffre
gash check
