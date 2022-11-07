#!/usr/bin/env sh

export PS
if ps -c | head -n1 | grep CLS 2>/dev/null >/dev/null
then
  PS="ps"
else
  PS="ps -c"
fi

sed "s/\\\$PS/$PS/g" "$(eval_gettext '$MISSION_DIR/goal/en.txt')"
unset PS
