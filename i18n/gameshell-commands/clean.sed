#!/usr/bin/sed -f

# remove trailing '::' for asciidoc's descriptions
s/::$//

# replace leading tabs used by asciidoc's descriptions by spaces
s/^\t/  /

# remove asciidoc's bold
s/\*\*//g

# remove asciidoc's italic
s/__//g

# remove trailing ' +' for asciidoc hard linebreaks
s/ +$//
