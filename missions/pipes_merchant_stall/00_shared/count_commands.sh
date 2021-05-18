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
  local NB_CMD=$(cat "$GSH_VAR/nb_commands")

  if [ "$last_cmd_1" != "$last_cmd_2" ] && [ -n "$pc" ] && ! echo "$pc" | grep -x "\s*gsh\s*\w*\s*" &> /dev/null
  then
    NB_CMD=$((NB_CMD+1))
    echo $NB_CMD > "$GSH_VAR/nb_commands"
  fi
  echo "($NB_CMD)"
}
export -f _cmd

PROMPT_COMMAND=$(echo "$PROMPT_COMMAND" | sed "s/\s*;\?\s*_cmd.*//")
if [ -z "$PROMPT_COMMAND" ]
then
    PROMPT_COMMAND="_cmd"
else
    PROMPT_COMMAND="$PROMPT_COMMAND;_cmd"
fi
