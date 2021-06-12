#!/bin/bash

# the ``history`` command is not in POSIX but it might be possible to use fc
# instead.
# PROMPT_COMMAND is only bash
# FIXME: we could try relying on fc' indices to avoid relying no
# PROMPT_COMMAND

echo 0 > "$GSH_VAR/nb_commands"
history -a
fc -l | tail -n 1 | awk '{print $1}' > "$GSH_VAR/last_command"

_cmd() {
  touch "$HISTFILE"
  history -a

  [ -e "$GSH_VAR/nb_commands" ] || return

  local last_cmd_1=$(fc -l | tail -n 1 | awk '{print $1}')
  local last_cmd_2=$(cat "$GSH_VAR/last_command")
  echo "$last_cmd_1" > "$GSH_VAR/last_command"

  local pc=$(tail -n1 "$HISTFILE")
  local nb_cmd=$(cat "$GSH_VAR/nb_commands")

  if [ "$last_cmd_1" != "$last_cmd_2" ] && [ -n "$pc" ] && ! echo "$pc" | grep -x '\s*gsh\s*\w*\s*' &>/dev/null
  then
    nb_cmd=$((nb_cmd+1))
    echo $nb_cmd > "$GSH_VAR/nb_commands"
  fi
  echo "($nb_cmd)"
}
export -f _cmd

PROMPT_COMMAND=$(echo "$PROMPT_COMMAND" | sed 's|[[:blank:]]*;\?[[:blank:]]*_cmd.*||')
if [ -z "$PROMPT_COMMAND" ]
then
    PROMPT_COMMAND="_cmd"
else
    PROMPT_COMMAND="$PROMPT_COMMAND;_cmd"
fi
