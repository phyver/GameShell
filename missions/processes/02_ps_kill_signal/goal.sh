#!/bin/sh

export PS
if ps -c | head -n1 | grep CLS 2>/dev/null >/dev/null
then
  PS="ps"
else
  PS="ps -c"
fi

envsubst '$PS' < "$(eval_gettext '$MISSION_DIR/goal/en.txt')"
unset PS
