#!/bin/sh

# NOTE: debian's sh (dash) is compiled without fc, so this won't work!

echo 0 > "$GSH_VAR/nb_commands"
fc -l | tail -n 1 | awk '{print $1}' > "$GSH_VAR/last_command"

_count_cmd() (
  touch "$HISTFILE"
  [ -e "$GSH_VAR/nb_commands" ] || return

  last_cmd_1=$(fc -l | tail -n 1 | awk '{print $1}')
  last_cmd_2=$(cat "$GSH_VAR/last_command")
  echo "$last_cmd_1" > "$GSH_VAR/last_command"

  pc=$(fc -l | tail -n 1 | awk '{print $2}')
  nb_cmd=$(cat "$GSH_VAR/nb_commands")

  if [ "$last_cmd_1" != "$last_cmd_2" ] && [ -n "$pc" ] && ! echo "$pc" | grep -x '\s*gsh\s*\w*\s*' &>/dev/null
  then
    nb_cmd=$((nb_cmd+1))
    echo $nb_cmd > "$GSH_VAR/nb_commands"
  fi
  echo "($nb_cmd) "
)

_PS1=$PS1
PS1='$(_count_cmd)'$PS1
