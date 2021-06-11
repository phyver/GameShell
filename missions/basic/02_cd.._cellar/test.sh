#!/bin/sh

cd
gsh assert_check false

cd "$(eval_gettext "\$GSH_HOME/Castle/Cellar")"
gsh assert_check true

cd "$(eval_gettext "\$GSH_HOME/Castle/Cellar")/.."
gsh assert_check false

cd
gsh assert_check false


