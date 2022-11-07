#!/usr/bin/env sh

mkdir -p "$GSH_CHEST"
echo "I'll be back." > "$GSH_CHEST/$(gettext "journal").txt"
gsh check
