#!/usr/bin/env sh

# need to be careful, as there are so many files in the Stall that
# rm Stall/* may not work.
case "$(pwd -P)" in
  "$(eval_gettext '$GSH_HOME/Stall')"*)
    cd "$GSH_HOME"
    rm -rf "$(eval_gettext '$GSH_HOME/Stall')"
    mkdir -p "$(eval_gettext '$GSH_HOME/Stall')"
    cd "$(eval_gettext '$GSH_HOME/Stall')"
    ;;
  *)
    rm -rf "$(eval_gettext '$GSH_HOME/Stall')"
    mkdir -p "$(eval_gettext '$GSH_HOME/Stall')"
    ;;
esac

rm -f "$GSH_TMP/nb_commands" "$GSH_TMP/last_command"

PS1=$_PS1
unset _PS1

rm -f "$GSH_TMP/nbUnpaid" "$GSH_TMP/amountKing"
