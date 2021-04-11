#!/bin/bash

shopt -s expand_aliases

# cf https://github.com/dylanaraps/neofetch/issues/433
case $OSTYPE in
    linux|linux-gnu|linux-gnueabihf)
        # shellcheck source=./lib/gnu_aliases.sh
        source "$GASH_BASE"/lib/gnu_aliases.sh
        ;;
    darwin*)
        # shellcheck source=./lib/macos_aliases.sh
        source "$GASH_BASE"/lib/macos_aliases.sh
        ;;
    openbsd*|FreeBSD|netbsd)
        # shellcheck source=./lib/bsd_aliases.sh
        source "$GASH_BASH"/lib/bsd_aliases.sh
        ;;
    *)
        read -erp "$(eval_gettext "Unknown system: OSTYPE=\$OSTYPE.
GameShell will use 'gnu-linux', without guarantee.
Please report this as a bug.
Press Enter to continue.")"
        # shellcheck source=./lib/gnu_aliases.sh
        source "$GASH_BASE"/lib/gnu_aliases.sh
        ;;
esac


# tests
if CANONICAL_PATH / &> /dev/null
then
  :
else
  echo "La fonction 'CANONICAL_PATH' ne fonctionne pas..."
  declare -f CANONICAL_PATH

  echo "Pour macOS, n'oubliez pas d'installer 'coreutils' (et 'md5sha1sum')
   $ brew install coreutils
   $ brew install md5sha1sum"
  exit
fi

# FIXME, remove with mission 11
if GET_MTIME / &> /dev/null
then
    :
else
    echo "La commande 'GET_MTIME' pour récupérer la date de modification"
    echo "d'un fichier ne fonctionne pas"
    declare -f GET_MTIME

    echo "j'essaie d'utiliser 'perl' pour ceci"
    function GET_MTIME() {
        perl -e 'print +(stat \$ARGV[0])[9], "\n"' "$@"
    }
    export -f GET_MTIME
    if $GET_MTIME / 2&> /dev/null
    then
        echo "ça marche !"
    else
        echo "ça ne marche pas, j'abandonne..."
        exit
    fi
fi
