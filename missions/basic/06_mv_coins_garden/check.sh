#!/bin/bash

# Receives coin number as first argument.
_mission_check() {
  local coin_name="$(gettext "coin")_$1"

    # Check that the coin is not in the garden.
    if [ -f "$(eval_gettext '$GSH_HOME/Garden')/$coin_name" ]
    then
      echo "$(eval_gettext "The coin '\$coin_name' is still in the garden!")"
      return 1
    fi

    # Check that the coin is in the chest.
    if [ ! -f "$GSH_CHEST/$coin_name" ]
    then
      echo "$(eval_gettext "The coin '\$coin_name' is not in the chest!")"
      return 1
    fi

    # Check that the contents of the coin.
    if ! check_file "$GSH_CHEST/$coin_name"
    then
      echo "$(eval_gettext "The coin '\$coin_name' has been tampered with...")"
      return 1
    fi

    # check the coin.
    if ! check_file "$GSH_CHEST/$coin_name"
    then
      echo "$(eval_gettext "The coin '\$coin_name' has been tampered with...")"
      return 1
    fi

    return 0
  }

if _mission_check 1 && _mission_check 2 && _mission_check 3
then
  true
else
  #FIXME: use clean.sh
  find "$GSH_HOME" -name "$(gettext "coin")_?" -type f -print0 | xargs -0 rm -f
  find "$(eval_gettext '$GSH_HOME/Garden')" -iname "*$(gettext "chest")*" -type f -print0 | xargs -0 rm -f
  find "$(eval_gettext '$GSH_HOME/Garden')" -iname "*$(gettext "hut")*" -type f -print0 | xargs -0 rm -f
  false
fi
