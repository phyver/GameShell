#!/bin/bash

shopt -s expand_aliases

# cf https://github.com/dylanaraps/neofetch/issues/433
case $OSTYPE in
  linux|linux-gnu|linux-gnueabihf)
    # shellcheck source=./lib/gnu_aliases.sh
    source "$GSH_ROOT"/lib/gnu_aliases.sh
    ;;
  darwin*)
    # shellcheck source=./lib/macos_aliases.sh
    source "$GSH_ROOT"/lib/macos_aliases.sh
    ;;
  openbsd*|FreeBSD|netbsd)
    # shellcheck source=./lib/bsd_aliases.sh
    source "$GSH_BASH"/lib/bsd_aliases.sh
    ;;
  *)
    read -erp "$(eval_gettext "Error: unknown system: OSTYPE=\$OSTYPE.
GameShell will use 'gnu-linux', without guarantee.")"
    read -erp "$(gettext "Press Enter")"
    # shellcheck source=./lib/gnu_aliases.sh
    source "$GSH_ROOT"/lib/gnu_aliases.sh
    ;;
esac

# vim: shiftwidth=2 tabstop=2 softtabstop=2
