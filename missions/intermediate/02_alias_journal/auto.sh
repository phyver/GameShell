#!/bin/sh

alias "$(gettext "journal")"="nano \"\$GSH_CHEST/$(gettext "journal").txt\""
gsh check
