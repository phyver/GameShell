#!/bin/sh

_mission_check() (
  cave="$(eval_gettext '$GSH_HOME/Mountain/Cave')"

  pc=$(. previous_commands.sh | head -n1)

  goal=$(realpath "$cave")
  current=$(realpath "$PWD")

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

  expected="$(cat "$GSH_TMP/book_of_potions/$(gettext 'page')_0"[34] | tail -n 16)"
  res="$(eval "$pc")"
  if [ "$res" != "$expected" ]
  then
    echo "$(gettext "Your previous command does not give the expected result...")"
    return 1
  fi
  return 0
)

_mission_check
