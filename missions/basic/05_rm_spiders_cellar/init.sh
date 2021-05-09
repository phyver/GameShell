#!/bin/bash

for i in $(seq 3)
do
    spider=$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(gettext "spider")$i
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

for i in $(seq 2)
do
    bat=$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(gettext "bat")$i
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
