#!/bin/sh

# en sed, parce que c'est plus rigolo...

sed '
H                   # put all lignes in hold buffer
/ $/{               # line ending with space (already in hold buffer)
    d               # empty pattern buffer
}
/[^ ]$/{            # line not ending with space
    s/.*//          # empty pattern buffer (can be replaced by 'z' (gnu extension))
    x               # exchange hold / pattern buffers
    s/^\s*\n//g     # remove initial newlines (added by H)
    s/\s*\n/ /g     # remove other newlines (replace them by single spaces)
}
'
