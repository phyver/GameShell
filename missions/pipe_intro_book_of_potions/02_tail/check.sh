#!/bin/sh

_mission_check() (
  cave="$(eval_gettext '$GSH_HOME/Mountain/Cave')"

  pc=$(. fc-lnr.sh | head -n1)

  goal=$(readlink-f "$cave")
  current=$(readlink-f "$PWD")

  if ! diff -q "$cave/$(gettext 'Book_of_potions')" "$GSH_TMP/book_of_potions" > /dev/null
  then
    echo "$(gettext "You altered the book...")"
    return 1
  fi

  if [ "$goal" != "$current" ]
  then
    echo "$(gettext "You are not in the cave with Servillus!")"
    return 1
  fi
  if ! echo "$pc" | grep -q 'tail'
  then
    echo "$(gettext "You have not used the 'tail' command!")"
    return 1
  fi

  echo "$pc" | grep -q 'gsh\s\s*check' && return 1

  expected="$(tail -n 9 "$GSH_TMP/book_of_potions/$(gettext 'page')_12")"
  res="$(eval "$pc")"
  if [ "$res" != "$expected" ]
  then
    echo "$(gettext "Your previous command does not give the expected result...")"
    return 1
  fi
  return 0
)

_mission_check
