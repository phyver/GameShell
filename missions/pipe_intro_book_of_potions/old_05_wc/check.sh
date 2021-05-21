#!/bin/bash

_mission_check() {
    local cave
    cave="$(eval_gettext '$GSH_HOME/Mountain/Cave')"

    local pc
    pc=$(fc -nl -2 -2 | grep 'wc')

    local goal
    goal=$(REALPATH "$cave")
    local current
    current=$(REALPATH "$PWD")

    if ! diff -q "$cave/$(gettext 'Book_of_potions')" "$GSH_VAR/book_of_potions" > /dev/null
    then
      echo "$(gettext "You altered the book...")"
      return 1
    fi

    if [ "$goal" != "$current" ]
    then
        echo "$(gettext "You are not in the cave with Servillus!")"
        return 1
    fi
    if [ -z "$pc" ]
    then
        echo "$(gettext "You have not used the 'wc' command!")"
        return 1
    fi

    echo $pc | grep 'gsh\s\s*check' && return 1

    local expected
    expected="$(tail -n +4 "$GSH_VAR/book_of_potions/$(gettext 'page')_06" | wc -l)"
    local res
    res="$(eval "$pc")"

    if [ "$res" != "$expected" ]
    then
        echo "$(gettext "Your previous command does not give the expected result...")"
        return 1
    fi
    return 0
}


_mission_check
