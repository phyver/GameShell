#!/usr/bin/env sh

# need to be careful, as there are so many files in the Stall that
# rm Stall/* may not work.
# find ... -exec rm "{}" -; is too slow
# so I use find ... -delete
# this is not POSIX but looks supported on Linux, OpenBSD, FreeBSD and MacOS
# (The POSIX alternative is to remove the Stall directory itself with rm -rf,
# and recreate it. But this can cause problems if the user is in the stall and uses a subshell for
# gsh check or gsh reset.)

find  "$(eval_gettext '$GSH_HOME/Stall')" -type f -delete
rm -f "$GSH_TMP/nb_commands" "$GSH_TMP/last_command"

PS1=$_PS1
unset _PS1

rm -f "$GSH_TMP/nbUnpaid" "$GSH_TMP/amountKing"
