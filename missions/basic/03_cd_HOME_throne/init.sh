#!/usr/bin/env sh

current=$(pwd -P)
expected=$(cd "$(eval_gettext '$GSH_HOME/Castle/Cellar')"; pwd -P)

if [ "$current" != "$expected" ]
then
    cd "$expected"
    expected=${expected#$GSH_ROOT}
    expected=${expected#/}
    echo "$(eval_gettext "You have been teleported to") .../$expected"
fi

unset current expected
