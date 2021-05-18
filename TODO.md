GameShell
=========

TODO NOW
--------

  - [ ] doc

  - [x] for processes in processes group, the shebang needs to be changed
        depending on the path to the interpreter
        in freebsd, the process name isn't taken from argv[0] but contains the
        interpreter name
  - [x] make the treasure messages stand out more (use some ASCII treasure
    chest?)
  - [x] `ls --literal` doesn't exist in freebsd
  - [x] giving missions to `start.sh` doesn't work outside `$GSH_ROOT`
  - [x] `date` doesn't have the same argument in freebsd (mission nostradamus)
  - [x] generate `.mo` if `.po` is newer
  - [x] crown not found
  - [x] `sed -i` doesn't have the same meaning in gnu / bsd
  - [x] `ls --color=auto` may not work
  - [x] inventory and grimoire: `tr` in freebsd doesn't accept binary
  - [x] move `checksum` to os_aliases.sh
  - [x] clean `lib` folder ?
  - [x] add specific functions for missions: `make_bin`, `sign_file`,
    `check_file`, `progress`
  - [x] put back progress bar on startup (possibly doing something nice)???
  - [x] try to make sure pager handles colors correctly
  - [x] use PAGER on gsh index


FOR LATER
---------

  - [ ] improve "progress_bar" function

  - [ ] minimize number of bashism's? (not sure if it is worth trying to be
        POSIX compliant though)

  - [ ] `gsh config` command to configure some options
         - verbose option (debug only)
         - ansi colors
         - quiet
         - pager
         - no box option

  - [ ] `gsh reset static` command

  - [ ] external `stats` commands (using awk?) for
       - `gsh stats sessions`
       - `gsh stats missions`
       - `gsh stats mission N`

  - [ ] make a copy of `$GSH_CHEST` at each mission to restore it in case of
        problem?

  - [ ] think again about using `ttyrec` and `ttyreplay`?

  - [ ] allow configuration of titlescreen and list of boxes


Existing missions
=================

TODO NOW
--------

  - [x] check all group with shared data have appropriate `deps.sh`
  - [x] in mission `misc/tr_caesar_shift`, make the chest appear in Merlin's
        office. Add a few thinks in the chest as well.
  - [x] `merchant_stall/pipe_2`: the prompt is not reset correctly
  - [x] do not count `gsh` commands in `pipes_merchant_stall/pipe_1`
  - [x] make sure there are at least a few grimoires with `pq` in stdin_stdout_stderr/stderr_dev-null_grimoires
  - [x] split mission `basic/rm_wildcard_spiders_cellar` in 2: first a lot of
    spiders to introduce wildcards, and then a lot of hidden spiders to
    introduce wildcards on hidden files
  - [x] put some ascii-art in different places:
          - [x] Merlin drawer?
          - [x] the observatory?
          - [x] Shed / Orchard?
          - [x] cellar?
  - [x] move missions 6 and 7 to the Garden
  - [x] change last mission in group "book_of_potions"
  - [x] change entrance to "great hall"
  - [x] translate "book_of_potions"
  - [x] mission 9: add other items to prevent using `cp *`
  - [x] mission 15: add a treasure to source `$GSH_CHEST/bashrc`, and suggest
        adding aliases like `gg => gsh goal` and `gc => gsh check`
  - [x] 28: mention `ls FILES` / `ls PATTERN`
  - [x] mission 24: change
  - [x] mission 25: change
  - [x] finish the hierarchy for missions
  - [x] rename all missions to have more informative names, eg
        `basic/01_cd_tower` and similar
  - [x] translate merlin.c / merlin.py in mission 30 cf
        https://mohan43u.wordpress.com/2012/07/02/gnu-gettext-yet-another-tutorial/


FOR LATER
---------

  - for missions that generate many files, remove most of them in `clean.sh`

  - merchant stall: clean python code for initialization

  - in missions re-evaluating the previous command, run it with timeout (if available).

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
