Mission creation guide
======================

To create a new mission you first need to answer the following questions:
- What do you want your mission to teach the player?
- What kind of scenario are you going for?
- What are the required commands to achieve the goal?

Once you have found a mission idea (and tested it in a normal shell) you can
go ahead and create the actual mission by following this guide.


Convention
----------

In the rest of this document, `$GSH_ROOT` will represent GameShell root
directory.


GameShell directory structure
-----------------------------

GameShell files are organized in several directories. The important ones when
creating missions are the following:

* `$GSH_HOME` contains the root of GameShell's "world", ie the file
  hierarchy where the player is expected to move around. It is created empty,
  and the missions will populate it.
  Even though this is also the `HOME` directory of the player, using
  `$GSH_HOME` is preferred over other abbreviations like `$HOME` or `~`.

* `$GSH_VAR` contains all the "hidden" data that may be created by a mission:
  temporary files, data required to check completion, scripts shared between
  missions, etc. Except in specific case ("dummy missions"), it is a good
  policy that each mission removes the files it creates.


Mission structure
-----------------

A mission is simply a directory with a set of files. This directory must be
somewhere under [`$GSH_ROOT/missions/`](../missions), typically inside
[`$GSH_ROOT/missions/contrib/`](../missions/contrib).

The directory is expected to have a name of the form `NB_NAME`, where `NB` is
number and `NAME` is a mission name (typically referring to the commands used
during the mission).

A mission will have the following structure, with most of these
files being optional:

    $GSH_ROOT/missions/NB_NAME
    ├── auto.sh
    ├── bashrc
    ├── bin
    │   ├── ...
    │   └── ...
    ├── check.sh                    REQUIRED
    ├── clean.sh                    OFTEN NEEDED
    ├── deps.sh
    ├── goal.txt / goal.sh          REQUIRED
    ├── i18n
    │   ├── ...
    │   └── ...
    ├── init.sh                     ALMOST REQUIRED
    ├── static.sh                   ALMOST REQUIRED
    ├── test.sh
    ├── treasure.sh
    └── treasure-msg.txt / treasure-msg.sh

Only 2 files are really required:
* `check.sh` to check for completion of the mission,
* `goal.txt` (or variant) to display the goal of the mission.

However, most missions will also need 2 other files:
* `static.sh` to initialize the static parts of the mission,
* `init.sh` to initialize the dynamic parts of the mission

The `static.sh` script is run once for all the mission before the first
mission is started. This allows to populate the world with the different
places where the missions will take place.

Th `init.sh` script is run whenever the mission is (re)started. It allows to
have missions with some randomized element to prevent brute force searching or
sharing of easy solutions among students.


We will now describe in details what's expected in those 4 files. (The other
files will be described in the next section.)


### `static.sh`

Like all `.sh` files defining the mission, `static.sh` is **sourced** by
GameShell.
It is first sourced when initializing a new game, and its typical use is
creating the "world map". A mission taking place in the castle's cellar would
use

    mkdir -p $GSH_HOME/Castle/Cellar

and would thus make sure the cellar exists when the game is started, even
though the first mission might take place somewhere else.

Because all missions need not be included in a customized GameShell archive,
it is important to create all the required places in `static.sh` and not
depend on them being created by another mission.

Because of that, sourcing `static.sh` shouldn't provoke an error if a place /
object already exists.

To avoid potential problem if a player removed part of the world, this file is
also sourced whenever the corresponding missions starts.

This file should always use absolute path by using `$GSH_HOME`. It can also
use the directory `$MISSION_DIR` that points to the mission's directory. This
is useful if the mission needs to copy some file into GameShell's world.


_Note_ that because this file is sourced, it can change directory or define
environment variables. This is discouraged because of the following reasons.

* Those files are not re-sourced when restarting a previous game. In that
  case, only the `static.sh` file corresponding to the current mission will be
  sourced.
* It is possible, when starting a new mission, that this file is sourced from
  a subshell. In that case, changing directory or defining environment
  variables will not have any effect.

If you need to define environment variables that will be available throughout
the game, use a `bashrc` file in the mission.


### `goal.txt` / `goal.sh`

The file `goal.txt` should be a UTF-8 encoded text file containing the
description of the mission. It is displayed when the player runs the command
`gsh goal`.

They usually follow the following pattern:

    Mission goal
    ============

    Find a frog in the swamp.


    Useful commands
    ===============

    cd PLACE
      Move to the given place, if accessible from you current location.

Meta-variables in commands should be in UPPERCASE.

If you require a "dynamic" goal, for example because it contains some
randomized data, you can replace `goal.txt` by `goal.sh`, which will be
sourced when the player runs the command `gsh goal`.
(Note however that randomized parts of the missions should probably be
generated by `init.sh`, not by `goal.sh`.)


If a Python3 interpreter is found, a fancy ASCII-art scroll box is
automatically added around the goal.


### `init.sh`

This file is sourced whenever the mission is started. It is typically used to
(re-)generate the dynamic parts of the mission.
_It is not sourced when a new game is started._

The corresponding `static.sh` file is sourced just before it, so `init.sh` can
depend on the static part existing.

Remember that this script is sourced every time the mission is (re)started. If
it creates files with randomized names, make sure you don't end up with
several versions of them by removing them first. (Or better yet, write a
`clean.sh` script.)


_Note_ that because this file is sourced, it can change directory or define
environment variables. In some cases however, this file can be sourced in a
subshell. (For example, if the previous `gsh check` command was run in a
subshell, as in `COMMAND | gsh check`...)
Whenever GameShell detects this situation (subshell with creation of
environment variables or change of `CWD`), a message asking the player to run
`gsh reset` is displayed. This will re-source de the `init.sh` file,
hopefully not in a subshell this time.


### `check.sh`

The `check.sh` is the only absolutely required file in a mission. It is
sourced when the player runs `gsh check` to validate (or not) the current
mission.

Since it is sourced (for uniformity with the other scripts), it requires some
care. It must be terminated by a command returning 0 (typically `true`) in
case of success, and by a command returning 1 (typically `false`) in case of
failure. In case of failure an explanation message is expected.

Whenever checking is even slightly complex, the script `check.sh` looks like

    _mission_check() {
      ...
      ...
    }

    _mission_check

Just like all the other scripts, `check.sh` is expected to keep the
environment clean: all local variables defined should be unset, etc. The only
exception is the function `_mission_check` that will be automatically unset.


_Note_ that because this file is sourced, it can change directory or define
environment variables. This is discouraged because sourcing might happen from
a subshell (in case of `COMMAND | gsh check` for example). In that case,
changing directory or defining environment variables will not have any effect.

If you need to define environment variables that will be available for the
remaining missions, use a `treasure.sh` file.



### `clean.sh` (optional)

This file is sourced:

* after the mission is checked (successfully or not),
* when the mission is "skipped" with `gsh skip`,
* when the mission is left with `gsh goto N`,
* when the player exits GameShell.

It should remove the parts of the missions that won't be necessary anymore,
either because they will be regenerated if the mission is restarted (by
`init.sh`), or because the mission was successfully validated.


The other files
---------------

The other files are not used as often but allow to customize GameShell.


### `bashrc` (optional)

This file is added to the global configuration of the bash session used during
the game. It can be used to define variables, aliases, functions, etc..
They will be available throughout the game.


### `deps.sh` (optional)

This is sourced when the mission is started. if the last return value is
`false` (anything different from `0`), the mission is cancelled.

This is typically used to check that the dependencies for the mission are met
(e.g., that every necessary command is available on the system).

If the dependencies are met the program should have no output. However, if the
dependencies are not met then a helpful error message is polite.


### `treasure.sh` (optional)

This file is sourced after the mission has been successfully validated (with
`gsh check`). It can be used to add new features as rewards to certain
missions.

Note that this file is also added to the global configuration so that the
reward is still available when you restart the game. As a consequence there
should be no output. (See the `treasure-msg.txt` file.)


### `treasure-msg.txt` / `treasure-msg.sh` (optional)

The file `treasure-msg.txt` is expected to be a UTF-8 encoded text file. It is
displayed when the mission is successfully completed.

It can be used to inform the player that a treasure (i.e., a feature installed
by `treasure.sh`) has been won.

Instead of `treasure-msg.txt`, a script `treasure-msg.sh` can be used to
generate a dynamic message. If it exists, `treasure-msg.sh` is sourced when
the mission is successfully completed.


### `bin/` (optional)

The files contained in this directory will be "copied" to the directory
`$LOCAL_BIN` to be made available to all missions. (The directory is not
in the global `PATH`, so those files are _not_ directly available to the
player.) This is particularly useful for "dummy" missions.

### `i18n/` (optional)

This directory contains the files related to [internationalization](i18n.md).


### `auto.sh` (optional)

This file is sourced when the command `gsh auto` is run. It should
automatically validate the corresponding mission. In other words, the commands
in this file should perform whatever steps are the necessary to complete the
mission, followed by the `gsh check` command.

That's mainly useful for testing, and those files aren't included in GameShell
archives by default.


### `test.sh` (optional)

This file is sourced by the command `gsh test`, which is only available in
debug mode. The `test.sh` script usually uses a mix of standard bash commands
and the special commands `gsh assert check true` (or `gsh assert check false`)
which make testing easier.

Those files are not included in GameShell archives.


Adding the mission to the `index.txt` file
----------------------------------------

TODO


Dummy missions
--------------

TODO
