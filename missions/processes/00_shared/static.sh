#!/usr/bin/env sh

# for some unkwnown reason, `ps -o pid,ppid,comm` doesn't find any process
# on the "macos-latest" image on github.
# I'm not sure if that's a problem with github images, or with macos.
# So, we use a different command when we detect this problem!

if ps -o pid,ppid,comm >/dev/null 2>/dev/null
then
  # standard ps -o pid,ppid,comm
  copy_bin "$MISSION_DIR/my_ps-linux" "$GSH_ROOT/.sbin/my_ps"
else
  # with additional options ps -ceo pid,ppid,comm
  copy_bin "$MISSION_DIR/my_ps-macos" "$GSH_ROOT/.sbin/my_ps"
fi

