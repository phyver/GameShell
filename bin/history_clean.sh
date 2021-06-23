#
# this script, together with its companion history_start.sh is used to record
# manually commands in a temporary history
# This is used to test missions that require inputing specific commands.
# It works with bash and zsh.
#
# To use, **source** history_start.sh. This will start a separate history.
# Use the function add_cmd to add commands to the history.
# When you're done, **source** history_clean.sh to go back to the original
# history.
#
case "$GSH_SHELL" in
  *bash)
    history -c    # clear history
    HISTFILE=$_HISTFILE
    history -r
    unset _HISTFILE
    ;;

  *zsh)
    fc -P # this pops the saved history back into place
    ;;
esac

rm -f "$GSH_TMP/tmp_history"
unset -f add_cmd
