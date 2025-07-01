meryl="Merwyn Ril' Avalon <merwyn@ewilan.book>"
ewilan="Ewilan Gil' Sayan <ewilan@ewilan.book>"
mkdir al_jeit
cd al_jeit
git init --initial-branch=spell
cp ../al_jeit_files/README.md  ../al_jeit_files/LICENSE ../al_jeit_files/dragon_killer.spell .
git add *
git commit -m "Initial spell" --author="Merwyn Ril' Avalon <merwyn@ewilan.book>"

version="changing_proportion"
cp ../al_jeit_files/dragon_killer.spell_${version}1 ./dragon_killer.spell
git commit -am "$(echo $version | sed -e "s/_/ /g")" --author="$meryl"

version="adding_earth"
git checkout -b $version
cp ../al_jeit_files/dragon_killer.spell_${version} ./dragon_killer.spell
git commit -am "$(echo $version | sed -e "s/_/ /g")" --author="$meryl"

version="changing_proportion"
git checkout spell 
cp ../al_jeit_files/dragon_killer.spell_${version}2 ./dragon_killer.spell
git commit -am "$(echo $version | sed -e "s/_/ /g")" --author="$meryl"

version="adding_light"
git checkout -b $version
cp ../al_jeit_files/dragon_killer.spell_${version} ./dragon_killer.spell
git commit -am "$(echo $version | sed -e "s/_/ /g")" --author="$ewilan"
