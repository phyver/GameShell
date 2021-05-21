#!/bin/bash

source gettext.sh

# Checking for the arguments.
if [ "$#" -ne 2 ]
then
  cat <<EOH
Usage:
  - Install the book in the given directory:
      $0 book path/to/dir/
  - Install the contents of the book in the given directory:
      $0 book path/to/dir
  - Install the torn page 5 as the given file:
      $0 page5 path/to/file
  - Install the torn page 6 as the given file:
      $0 page6 path/to/file
EOH
  exit -1
fi

# Takes installation directory as argument (with or without final '/').
install_book() {
  local BOOK
  BOOK="$1"
  if [[ "$BOOK" == */ ]]
  then
    BOOK="$BOOK$(gettext "Book_of_potions")"
  fi

  mkdir -p "$BOOK"
  # NOTE: option --supress-matched doesn't exist in freebsd, nor does the "{*}" repetition
  csplit -ks -f "$BOOK/$(gettext "page")_" "$(eval_gettext '$MISSION_DIR/book_of_potions/en.txt')" "/^==.*/" "{99}" 2> /dev/null
  local f
  for f in "$BOOK/$(gettext "page")_"*
  do
      sed-i "/^==.*/d" "$f"
  done

  mv "$BOOK/$(gettext "page")_00" "$BOOK/$(gettext "table_of_contents")"
}

# Takes destination file as argument.
install_page5() {
  local SRC
  SRC="$(eval_gettext '$MISSION_DIR/torn_page5/en.txt')"
  mkdir -p "$(basename "$1")"
  cp "$SRC" "$1"
}

# Takes destination file as argument.
install_page6() {
  local SRC
  SRC="$(eval_gettext '$MISSION_DIR/torn_page6/en.txt')"
  mkdir -p "$(basename "$1")"
  cp "$SRC" "$1"
}

case $1 in
  "book")
    install_book "$2"
    ;;
  "page5")
    install_page5 "$2"
    ;;
  "page5")
    install_page5 "$2"
    ;;
  *)
    echo "The first argument must be 'book', 'page5' or 'page6'."
    exit -1
esac
