#!/bin/sh

maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"
case $(pwd -P) in
  "$maze"/?*)
    cd "$maze"
    echo "$(gettext "Sei tornato/a all'entrata del labrinto...")"
    ;;
esac

case "$maze" in
  */World/*)
    rm -rf "$maze"/?*
    ;;
  *)
    echo "Errore: Non voglio rimuovere il contenuto di $maze!"
    exit 1
    ;;
esac
unset maze
