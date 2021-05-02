#!/bin/bash

BOOK="$(eval_gettext '$GASH_HOME/Mountain/Cave')/$(gettext "Book_of_Potions")"

mkdir -p "$BOOK"

csplit -s --suppress-matched --prefix="$BOOK/$(gettext "page")_" \
  "$(eval_gettext '$MISSION_DIR/book_of_potions/en.txt')" "/^==.*/" "{*}"

mv "$BOOK/$(gettext "page")_00" "$BOOK/$(gettext "table_of_contents")"

# Save a copy of the book to check that it was not altered later.
rm -rf "$GASH_MISSION_DATA/book_of_potions"
cp -r "$BOOK" "$GASH_MISSION_DATA/book_of_potions"

unset BOOK
