#
# this script, together with its companion alt_history_start.sh is used to record
# manually commands in a temporary history
# This is used to test missions that require inputing specific commands.
# It works with bash and zsh.
#
# To use, **source** alt_history_start.sh. This will start a separate history.
# Use the function add_cmd to add commands to the history.
# When you're done, **source** alt_history_stop.sh to go back to the original
# history.
#
# NOTE, on old versions of bash (e.g. in macos), fc removes the last command, even
# if it is not "fc" itself. In the game, it will remove 'gsh check', which is not
# a problem, but during testing, it will remove the last command that was manually
# inserted. It is thus important to manually add 'gsh check' (or any dummy command)
# with 'add_cmd'.
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
