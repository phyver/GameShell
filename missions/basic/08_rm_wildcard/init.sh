#!/bin/bash

CELLAR=$(eval_gettext "\$GSH_HOME/Castle/Cellar")
mkdir -p "$CELLAR"
rm -f "$CELLAR"/.??*

for I in $(seq -w 10)
do
  bat=${CELLAR}/.${RANDOM}_${I}_$(gettext "bat")
  case "$((RANDOM % 3))" in
      0)
          cat <<'EOS'>$bat

   /\                 /\
  / \'._   (\_/)   _.'/ \
 /_.''._'--('.')--'_.''._\
 | \_ / `;=/ " \=;` \ _/ |
  \/ `\__|`\___/`|__/`  \/
   `      \(/|\)/       `
           " ` "            jgs

EOS
          ;;
      1)
          cat <<'EOS'>$bat

 /\                 /\
/ \'._   (\_/)   _.'/ \
|.''._'--(o.o)--'_.''.|
 \_ / `;=/ " \=;` \ _/
   `\__| \___/ |__/`
        \(_|_)/             jgs

EOS
          ;;
      2)
          cat <<'EOS'>$bat

   =/\                 /\=
    / \'._   (\_/)   _.'/ \
   / .''._'--(o.o)--'_.''. \
  /.' _/ |`'=/ " \='`| \_ `.\
 /` .' `\;-,'\___/',-;/` '. '\
/.-'       `\(-V-)/`       `-.\
`            "   "      jgs   `

EOS
          ;;
    esac
done
unset bat

for I in $(seq -w 100)
do
  spider=${CELLAR}/.${RANDOM}_${I}_$(gettext "spider")
  case "$((RANDOM % 3))" in
      0)
          cat <<'EOS'>$spider

_\(_)/_
 /(o)\              jgs

EOS
          ;;
      1)
          cat <<'EOS'>$spider
     __
  | /  \ |
 \_\\  //_/
   //()\\
   \\  //           jgs

EOS
          ;;
      2)
          cat <<'EOS'>$spider
       _.._
     .'    '.
    /   __   \
 ,  |   ><   |  ,
. \  \      /  / .
 \_'--`(  )'--'_/
   .--'/()\'--.
  /  /` '' `\  \
    |        |
     \      /       jgs

EOS
          ;;
    esac
done
unset spider


find "$CELLAR" -maxdepth 1 -name ".*$(gettext "bat")" | sort | checksum > "$GSH_VAR/bats"

unset CELLAR D I S
