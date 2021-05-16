#!/bin/bash

cat > "$(eval_gettext '$GSH_HOME/Castle/Main_building/Library')/$(gettext "Greek_Latin_and_other_modern_languages")" <<EOB
Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat.  Duis aute irure dolor in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
EOB

echo "$(gettext "The book 'Mathematics_101' contains all the anwsers for the exam.

You just need to copy all the lines in this book.")" \
    > "$(eval_gettext '$GSH_HOME/Castle/Main_building/Library')/.$(gettext "How_to_cheat_for_exams")"


book="$(eval_gettext '$GSH_HOME/Castle/Main_building/Library')/$(gettext "Mathematics_101")"
rm -f "$book"
questions="$GSH_VAR"/arith.txt
rm -f "$questions"

for _ in $(seq 100)
do
    a=$((1+RANDOM%100))
    b=$((1+RANDOM%100))
    c=$((a * b))
    echo $c >> "$book"
    echo "$a * $b = ?? |$c" >> "$questions"
done
