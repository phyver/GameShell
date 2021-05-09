#!/bin/bash

case "$(pwd)" in
    "$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(gettext ".Lair_of_the_spider_queen")"*)
        cd "$(eval_gettext '$GSH_HOME/Castle/Cellar')"
        echo "$(gettext "You are back in the cellar.")"
        ;;
esac
rm -rf "$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(gettext ".Lair_of_the_spider_queen")"*

r1=$(checksum $RANDOM)
r2=$(checksum $RANDOM)
lair="$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(gettext ".Lair_of_the_spider_queen") ${r1} ${r2}"
mkdir -p "$lair"

r1=$(checksum $RANDOM)
r2=$(checksum $RANDOM)
queen="${r1}_$(gettext "spider_queen")_$r2"
cat <<'EOS' > "$lair/$queen"
              (
               )
              (
        /\  .-"""-.  /\
       //\\/  ,,,  \//\\
       |/\| ,;;;;;, |/\|
       //\\\;-"""-;///\\
      //  \/   .   \/  \\
     (| ,-_| \ | / |_-, |)
       //`__\.-.-./__`\\
      // /.-(() ())-.\ \\
     (\ |)   '---'   (| /)
      ` (|           |) `
        \)           (/     jgs
EOS

r1=$(checksum $RANDOM)
r2=$(checksum $RANDOM)
bat="${r1}_$(gettext "baby_bat")_$r2"
cat <<'EOS' > "$lair/$bat"
      _   ,_,   _
     / `'=) (='` \
    /.-.-.\ /.-.-.\
    `      "      `   jgs
EOS

date +%s > "$GSH_VAR/start_time"

unset lair queen r1 r2

set -o noglob
