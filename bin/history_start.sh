#
# this script, together with its companion history_clean.sh is used to record
# manually commands in a temporary history
# This is used to test missions that require inputing specific commands.
# It works with bash and zsh.
#
# To use, **source** history_start.sh. This will start a separate history.
# Use the function add_cmd to add commands to the history.
# When you're done, **source** history_clean.sh to go back to the original
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
    history -a    # append unsaved commands to history file
    _HISTFILE=$HISTFILE
    HISTFILE="$GSH_TMP/tmp_history"
    history -c
    add_cmd() { history -s "$@" ; }
    ;;
  *zsh)
    fc -p "$GSH_TMP/tmp_history" # this pushes the current history on a stack to start a new one
    add_cmd() { print -s "$@" ; }
    ;;
esac
