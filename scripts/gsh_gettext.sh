#!/bin/sh

if [ -z "$GSH_NO_GETTEXT" ]
then
. gettext.sh 2>/dev/null
fi

if ! command -v eval_gettext >/dev/null
then

export GSH_NO_GETTEXT=1

gettext() {
  echo "$1"
}

eval_gettext() {
  eval "echo \"$1\""
}

fi
