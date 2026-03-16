#!/usr/bin/env sh

_mission_check() {
    if ! git config --global user.name > /dev/null
    then
      echo "$(eval_gettext "You haven't configured your name.")"
      rm -f "$GSH_HOME/.gitconfig"
      return 1
    fi

    if ! git config --global user.email > /dev/null
    then
      echo "$(eval_gettext "You haven't configured your email.")"
      rm -f "$GSH_HOME/.gitconfig"
      return 1
    fi

    # save git config file for restoring
    cp "$GSH_HOME/.gitconfig" "$GSH_TMP/gitconfig"

    return 0
}
_mission_check
