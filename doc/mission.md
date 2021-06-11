Mission creation guide
======================


Convention
----------

In the rest of this document, `$GSH_ROOT` will represent GameShell's root
directory.


GameShell directory structure
-----------------------------

GameShell files are organized in several directories. The important ones when
creating missions are the following:

* `$GSH_HOME` contains the root of GameShell's "world": the file hierarchy
  where the player is expected to move around. It is initially empty, and the
  missions populate it.
  Even though this is also the `HOME` directory of the player, using
  `$GSH_HOME` is preferred over other abbreviations like `$HOME` or `~`.

* `$GSH_VAR` contains all the "hidden" data that may be created by a mission:
  temporary files, data required to check completion, data shared between
  missions, etc. Except in specific case ("dummy missions"), it is a good
  policy that each mission removes the files it creates.


Mission structure
-----------------

A mission is simply a directory with a set of files. This directory must be
somewhere under [`$GSH_ROOT/missions/`](../missions), typically inside
[`$GSH_ROOT/missions/contrib/`](../missions/contrib).

A mission has the following structure, most of the files being optional:

```
$GSH_ROOT/missions/.../MISSION_NAME
├── auto.sh
├── gshrc
├── bin
│   ├── ...
│   └── ...
├── check.sh                    REQUIRED
├── clean.sh                    OFTEN NEEDED
├── goal.txt / goal.sh          REQUIRED
├── i18n
│   ├── ...
│   └── ...
├── init.sh                     ALMOST REQUIRED
├── sbin
│   ├── ...
│   └── ...
├── static.sh                   ALMOST REQUIRED
├── test.sh
├── treasure.sh
└── treasure-msg.txt / treasure-msg.sh
```

Only 2 files are really required:
* `check.sh` to check for completion of the mission,
* `goal.txt` (or variant) to display the goal of the mission.

However, most missions will also need 2 other files:
* `static.sh` to initialize the static parts of the mission,
* `init.sh` to initialize the dynamic parts of the mission

The `static.sh` script is run during GameShell's initialisation (before the
first mission is even started). This allows to populate the world with the
different places (i.e., directories) where the missions will take place.

Th `init.sh` script is run whenever the mission is (re-)started. It allows to
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
```sh
mkdir -p "$GSH_HOME/Castle/Cellar"
```
and would thus make sure the cellar exists when the game is started, even
though the first mission might take place somewhere else.

Because all missions need not be included in a customized GameShell archive,
it is important to create all the required places in `static.sh` and not
depend on them being created by another mission.

Because of that, sourcing `static.sh` shouldn't provoke an error if a place /
object already exists: you should for example use `mkdir -p` to create
directories.

To avoid potential problems if a player removed part of the world, this file is
also sourced whenever the corresponding missions is (re-)started.

This file should always use absolute path by using `$GSH_HOME`. It can also
use the directory `$MISSION_DIR` that points to the mission's directory. This
is useful if the mission needs to copy files into GameShell's world.


_Note_ that because this file is sourced, it can change directory or define
environment variables. This is discouraged because of the following reasons.

* Those files are not re-sourced when restarting a previous game. In that
  case, only the `static.sh` file corresponding to the current mission will be
  sourced.
* It is possible, when starting a new mission, that this file is sourced from
  a subshell. In that case, changing directory or defining environment
  variables will not have any effect.

If you need to define environment variables that will be available throughout
the game, use a `gshrc` file in the mission.


### `goal.txt` / `goal.sh`

The file `goal.txt` should be a UTF-8 encoded text file containing the
description of the mission. It is displayed when the player runs the command
`gsh goal`.

They usually follow the following pattern:
```
Mission goal
============

Find a frog in the swamp.


Useful commands
===============

cd PLACE
  Move to the given place, if accessible from you current location.
```

For uniformity, meta-variables in commands should be in UPPERCASE.

If you require a "dynamic" goal, for example because it contains some
randomized data, you can replace `goal.txt` by `goal.sh`, which will be
sourced each time the player runs `gsh goal`.
(Note that randomized parts of the missions should probably be generated by
`init.sh`, not by `goal.sh`.)


### `init.sh`

This file is sourced whenever the mission is started. It is typically used to
(re-)generate the dynamic parts of the mission.
_It is not sourced during the initialisation of GameShell._

The corresponding `static.sh` file is sourced just before it, so `init.sh` can
depend on the static part existing.

Remember that this script is sourced every time the mission is (re-)started. If
it creates files with randomized names, make sure you don't end up with
several versions of them by removing them first. (Or better yet, write a
`clean.sh` script.)


_Note_ that because this file is sourced, it can change directory or define
environment variables. In some cases however, this file can be sourced in a
subshell. (For example, if the previous `gsh check` command was run in a
subshell, as in `COMMAND | gsh check`...)
Whenever GameShell detects this situation (subshell with creation of
environment variables or change of `CWD`), a message asking the player to run
`gsh reset` is displayed. This will re-source de the `init.sh` file, hopefully
not in a subshell this time.


**If the last return value is `false` (anything different from `0`), the mission
is cancelled.**

This is typically used to check that the dependencies for the mission are met
(e.g., that every necessary command is available on the system). When some
dependency is not met then a helpful error message is polite.


### `check.sh`

The `check.sh` is the only required file in a mission. It is sourced when the
player runs `gsh check` to validate (or not) the current mission.

Since it is sourced (for uniformity with the other scripts), it requires some
care. It must end with a command returning 0 (typically `true`) in case of
success, and by a command returning something else (typically `false`) in case
of failure. In case of failure an explanation message is expected.

Whenever checking is even slightly complex, the script `check.sh` usually
looks like
```sh
_mission_check() {
  ...
  ...
}

_mission_check
```

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

Before sourcing this file, a variable `GSH_LAST_ACTION` is set to the command
that sourced it:
* `exit`
* `skip`
* `check_true`
* `check_false`
* `goto`
* `reset`
* `hardreset`
* `assert`


The other files
---------------

The other files are not used as often but allow to customize GameShell.


### `gshrc` (optional)

This file is added to the global configuration of the bash session used during
the game. It can be used to define variables, aliases, functions, etc..
They will be available throughout the game.


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

A fancy treasure chest is added to the left of the message. The width of the
message shouldn't be more than 45 characters wide.


### `bin/` (optional)

The files contained in this directory will be "copied" to the directory
`$GSH_BIN`. The directory is in the global `PATH`, so those files are
directly available to the player.


### `sbin/` (optional)

The files contained in this directory will be "copied" to the directory
`$GSH_SBIN`. (The directory is not in the global `PATH`, so those
files are _not_ directly available to the player.) This is particularly useful
for "dummy" missions.


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

When run without arguments GameShell will get the list of mission from the
file `$GSH_ROOT/missions/index.txt`.

You can give a list of `index.txt` files and mission directories as arguments
of GameShell if you want to customize the list / order of missions. This is
particularly useful when testing a new mission:
```sh
$ ./start.sh -RD missions/contrib/my_new_mission
```
(The `-F` flag forces execution in the source directory, the `-R` flag resets
the previous game, and the flag `-D` will run GameShell in "debug" mode.)


Some available functions
------------------------

The file `$GSH_ROOT/lib/missions_utils.sh` defines a couple of useful
functions.


Dummy missions
--------------

"Dummy" missions are used to share data between missions. A mission is "dummy"
* either when it doesn't contain a `check.sh` script,
* or it is listed with a "`!`" in front of its name in the `index.txt` file.

A dummy mission is used during the initialisation phase, so that it can
contain a `static.sh` file. It can for example be used to share executable
files in its `bin` or `sbin` directory.

It can also contain data that will be used by other missions:
* either the `static.sh` file can copy the data to `$GSH_VAR` (or some other
  place),
* or the real missions can use symbolic links (with relative path) to refer to
  that data.

A real mission in `$GSH_MISSIONS/contrib/jungle/01_hide_elephant` could for
example use
```sh
cp "$MISSION_DIR/../00_shared/ascii-art/elephant.txt" "$GSH_HOME/Jungle/"
```

_Note:_ don't forget to include dummy missions in the corresponding
`index.txt` file, or it won't be included in GameShell executable archives by
default.


If several missions share an `init.sh` script (or `clean.sh`, or whatever), it
can be included in a dummy mission, while the actual missions use a symbolic
link to it.

_Note:_ when sourcing a symbolic link,
* the variable `$MISSION_DIR` refers to the _physical_ directory containing
  the file (the symbolic link is expanded),
* the variable `$MISSION_NAME` refers to the _logical_ name of the mission
  containing the file (the symbolic link is _not_ expanded).
* the variable `$MISSION_NB` refers to the index of the _logical_ mission.
