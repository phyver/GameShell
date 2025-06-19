#!/usr/bin/env sh

cd
gsh assert check false

cd "$(eval_gettext "\$GSH_HOME/Castle/Cellar")"
gsh assert check true

cd "$(eval_gettext "\$GSH_HOME/Castle/Cellar")/.."
gsh assert check false

cd
gsh assert check false


