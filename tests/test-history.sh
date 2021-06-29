#!/bin/sh

if [ -z "$GSH_TMP" ]
then
  export GSH_TMP=.
fi

test_history() {
  case "$SHELL" in
    *bash)

      bash -c '
      export GSH_SHELL=bash
      export HISTFILE="$GSH_TMP/history"
      history -r
      export HISTSIZE=10
      export HISTFILESIZE=10
      fc -ln
      source ./bin/alt_history_start.sh
      add_cmd A
      add_cmd B
      add_cmd C
      fc -ln
      source ./bin/alt_history_stop.sh
      fc -ln
      '
      ;;

    *zsh)
      zsh -c '
      export GSH_SHELL=zsh
      export HISTFILE="$GSH_TMP/history"
      fc -R
      export HISTSIZE=10
      export SAVEHIST=10
      fc -ln
      source ./bin/alt_history_start.sh
      add_cmd A
      add_cmd B
      add_cmd C
      fc -ln
      source ./bin/alt_history_stop.sh
      fc -ln
      '
      ;;
  esac
}


echo a > "$GSH_TMP/history"
echo b >> "$GSH_TMP/history"
echo c >> "$GSH_TMP/history"

output=$(test_history | tr -dc "abcABC")
rm -f "$GSH_TMP/history" "$GSH_TMP/tmp_history"
if [ "$output" != "abcABCabc" ]
then
  echo "PROBLEM"
  exit 1
fi
