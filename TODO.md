GameShell
=========

TODO NOW
--------

  - [ ] doc

  - [ ] try to make sure pager handles colors correctly

  - [ ] use PAGER on gsh index


FOR LATER
---------

  - [ ] `gsh config` command to configure some options (boxes, color,
        verbose_source, quiet, pager...)

  - [ ] `gsh reset static` command

  - [ ] external `stats` commands (using awk?) for
       - `gsh stats sessions`
       - `gsh stats missions`
       - `gsh stats mission N`

  - [ ] make a copy of `$GSH_CHEST` at each mission to restore it in case of
        problem?

  - [ ] think again about using `ttyrec` and `ttyreplay`?


Existing missions
=================

TODO NOW
--------

  - [ ] 28: mention `ls FILES` / `ls PATTERN`

  - [ ] translate merlin.c / merlin.py in mission 30 cf
        https://mohan43u.wordpress.com/2012/07/02/gnu-gettext-yet-another-tutorial/

  - [ ] check all group with shared data have appropriate `deps.sh`

  - [ ] finish the hierarchy for missions

  - [ ] rename all missions to have more informative names, eg
        `basic/01_cd_tower` and similar

  - [ ] mission 9: add other items to prevent using `cp *`

  - [ ] mission 15: add a treasure to source `$GSH_CHEST/bashrc`, and suggest
        adding aliases like `gg => gsh goal` and `gc => gsh check`


FOR LATER
---------

  - clean.sh for GSH_CHEST mission, using GSH_ACTION

  - mission 9: clean the `check.sh`

  - mission 33, 34: clean python code for initialization

  - mission 24, 25: Rodolphe once had mission 25 initialized in a subshell!

  - in missions re-evaluating the previous command, run it with timeout (if available).

  - mission 23: too complex, split in 2 missions
    (or wait until Rodolphe has finished the book of potions mission group)

  - mission 14: allow using another editor if `$EDITOR` is set

  - some `test.sh`: don't use ranges in `history -d ...` because older
    versions of bash do not support it.

  - make sure all missions have a `test.sh`, and that it works in English and
    French

  - what's the deal with redirecting `fc -nl` changing the last command in
    history?


Some missions ideas
===================


  - using `ls -l` and some other common options

  - `ls *`   vs  `ls -d *`

  - using `less` / `more` to paginate output of a command

  - `PATH` variable

  - symbolic links ("make a secret passage from one room to another"?)

  - using `sort` / `uniq`

  - search through the history with `C-r`

  - history of commands

  - more missions using shell patterns

  - something with regular expressions and `grep`

  - create empty files with `touch`, update modification date

  - scripting: `for` loops on files

  - `pushd` / `popd`

  - `comm` to compare before / after file

  - `paste`

  - `join`

  - `wget` / `curl`

  - `tar` / `zip`
    - Idea: receive/send a package (archive = packaging).

  - `fuser` / `lsof`

  - print prime numbers less than N with a combination of `seq` / `factor` /
    `grep` / `cut`

  - only activate completion once the first appropriate mission has been
    completed
    (put `bind 'set disable-completion' on` in the first mission's `bashrc`,
    and `bind ... of` in some mission' `treasuse.sh`)

  - alias `pick` for moving a file into the chest
    NOTE: it probably requires GNU's `mv` with option `-t`

  - alias `inventory` to list the content of the chest (with `nl`)

  - function `drop` to move a file from the chest to the CWD

  - "summary missions" to practice what has been learnt at the end of the
    `missions/basic` mission group. We could ask the player o tidy up the
    pantry, initially filled with a big mess of files (fruits, cheese, meat,
    wine, trash, ...) and the player would have to organise everything into
    a specified directory structure: fruits in "barels", cheese on "shelves",
    get rid of trash, ...

  - manage an inventory (or the `Chest`) with aliases:
    - `alias inventory='ls ~/Forest/Hut/Chest | nl` to show the inventory,
    - `alias pick='mv -t ~/Forest/Hut/Chest` to pick an item,
    - `alias drop='...'` to drop an item at the current location.
