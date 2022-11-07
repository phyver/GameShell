#!/usr/bin/env sh

rm -f "$GSH_CHEST/$(gettext "journal").txt"
gsh assert check false

touch "$GSH_CHEST/$(gettext "journal").txt"
gsh assert check false

echo "TEST" > "$GSH_CHEST/$(gettext "journal").txt"
gsh assert check true

rm -f "$GSH_CHEST/$(gettext "journal").txt"
