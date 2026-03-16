#!/usr/bin/env sh

_mission_check() {
    spell=$(gettext "glowing_finger.spl")
    repo=$(eval_gettext '$GSH_HOME/Castle/Lab/Spellbook')
    spellbook=$(basename "$repo")

    if ! git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1
    then
        echo "$(eval_gettext 'Your $spellbook directory is not a git repository.')"
        return 1
    fi

    if [ ! -f "$repo/$spell" ]
    then
        echo "$(eval_gettext 'The Glowing Finger spell scroll is not in your $spellbook repository.')"
        return 1
    fi

    if [ "$(git -C "$repo" status --porcelain | wc -l)" -ne 0 ]
    then
        echo "$(eval_gettext 'Your $spellbook repository contains untracked files.')"
        return 1
    elif ! git -C "$repo" diff --cached --quiet
    then
        echo "$(eval_gettext 'Your $spellbook repository contains unstaged changes.')"
        return 1
    elif ! git -C "$repo" diff --cached --quiet
    then
        echo "$(eval_gettext 'Your $spellbook repository contains uncommited changes.')"
        return 1
    fi

    # make sure the hash numbers are using lowercase hex digits (that should
    # already be the case)
    hash=$(git -C "$repo" rev-parse HEAD | tr 'A-F' 'a-f')
    printf "%s " "$(gettext "What is your last commit's hash number?")"
    read -r hash_answer
    hash_answer=$(echo "$hash_answer" | tr 'A-F' 'a-f')
    if [ ${#hash_answer} -lt 7 ]
    then
      echo "$(gettext "You must give at least 7 characters for a hash number.")"
      return 1
    fi
    if echo "$hash_answer" | grep -vq "^[0-9a-fA-F]*$"
    then
      echo "$(gettext "This hash number is invalid.")"
      return 1
    fi
    case "$hash" in
      $hash_answer*)
        return 0
        ;;
      *)
        if git -C "$repo" log --format="%H" | grep -q "^$hash_answer"
        then
          echo "$(gettext "This isn't the last commit's hash number.")"
        else
          echo "$(gettext "This isn't a valid hash number in your repository.")"
        fi
        return 1
        ;;
    esac
}
_mission_check
