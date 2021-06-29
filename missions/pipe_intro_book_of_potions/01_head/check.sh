#!/bin/sh

_mission_check() (
  cave="$(eval_gettext '$GSH_HOME/Mountain/Cave')"

  pc=$(. fc-lnr.sh | head -n1)

  goal=$(readlink-f "$cave")
  current=$(readlink-f "$PWD")

  if ! diff -q "$cave/$(gettext 'Book_of_potions')" "$GSH_TMP/book_of_potions" >/dev/null
  then
    echo "$(gettext "You altered the book...")"
    return 1
  fi

  if [ "$goal" != "$current" ]
  then
      echo "$(gettext "You are not in the cave with Servillus!")"
      return 1
  fi
  if ! echo "$pc" | grep -q 'head'
  then
      echo "$(gettext "You have not used the 'head' command!")"
      return 1
  fi

  echo "$pc" | grep -q 'gsh\s\s*check' && return 1

  expected="$(head -n 6 "$GSH_TMP/book_of_potions/$(gettext 'page')_07")"
  res="$(eval "$pc")"

  if [ "$res" != "$expected" ]
  then
      echo "$(gettext "Your previous command does not give the expected result...")"
      return 1
  fi
  return 0
)

_mission_check
