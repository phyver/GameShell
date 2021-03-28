#!/bin/bash

shopt -s expand_aliases

# cf https://github.com/dylanaraps/neofetch/issues/433
case $OSTYPE in
    linux|linux-gnu|linux-gnueabihf)
        source $GASH_BASE/lib/gnu_aliases.sh
        ;;
    darwin*)
        source $GASH_BASE/lib/macos_aliases.sh
        ;;
    openbsd*|FreeBSD|netbsd)
        # non testé
        source $GASH_BASH/lib/bsd_aliases.sh
        ;;
    *)
        echo "la variable \$OSTYPE est égale à $OSTYPE"
        echo "je ne reconnais pas ce système..."
        exit
        ;;
esac


# tests
if CANONICAL_PATH / &> /dev/null
then
  :
else
  echo "La fonction 'CANONICAL_PATH' ne fonctionne pas..."
  declare -f CANONICAL_PATH

  echo "Pour macOS, n'oubliez pas d'installer 'coreutils' (et 'md5sha1sum')"
  echo "   $ brew install coreutils"
  echo "   $ brew install md5sha1sum"
  exit
fi

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
