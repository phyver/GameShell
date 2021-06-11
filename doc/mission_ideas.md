Some missions ideas
===================


  - using `ls -l` and some other common options

  - `ls *`   vs  `ls -d *`

  - using `less` / `more` to paginate the output of a command

  - meaning of the `PATH` variable

  - symbolic links (_"Make a secret passage from one room to another."_)

  - using `sort` / `uniq`

  - search through the history with `C-r`

  - history of commands

  - more missions using shell patterns `[...]` and `[^...]` (or `[!...]` as
    specified by POSIX, but this interacts with bash' history expansion)

  - mission using `*/*` patterns to explain that `/` are not captured by
    wildcards

  - simple regular expressions and `grep`

  - create empty files with `touch`, update modification date

  - scripting: `for` loops on files

  - `pushd` / `popd`

  - `comm` to compare before / after file

  - `paste` (restore a torn treasure map)

  - `join`

  - `wget` / `curl`

  - `tar` / `zip`
    - Idea: receive/send a package (archive = packaging).

  - `fuser` / `lsof`

  - print prime numbers less than N with a combination of `seq` / `factor` /
    `grep` / `cut`

  - only activate completion once the first appropriate mission has been
    completed
    (put `bind 'set disable-completion' on` in the first mission's `gshrc`,
    and `bind ... of` in some mission' `treasuse.sh`)

  - "summary missions" to practice what has been learnt at the end of the
    `missions/basic` mission group. We could ask the player o tidy up the
    pantry, initially filled with a big mess of files (fruits, cheese, meat,
    wine, trash, ...) and the player would have to organise everything into
    a specified directory structure: fruits in "barrels", cheese on "shelves",
    get rid of trash, ...

  - manage an inventory (or the `Chest`) with aliases:
    - `alias inventory='ls ~/Forest/Hut/Chest | nl` to show the inventory,
    - `alias pick='mv -t ~/Forest/Hut/Chest` to pick an item (NOTE: it
      probably requires GNU's `mv` with option `-t`)
    - `alias drop='...'` to drop an item at the current location (NOTE: that's
      probably better to use a function for that, no?)
