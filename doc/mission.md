Mission creation guide
======================

To create a new mission you first need to answer the following questions:
- What do you want your mission to teach the player?
- What kind of scenario are you going for?
- What are the required commands to achieve the goal?

Once you have found a mission idea (and tested it in a normal shell) you can
go ahead and create the actual mission by following this guide.

Directory structure
-------------------

A mission simply correspond to a set of files (following a naming convention)
placed in a directory under [missions/](../missions). The mission folder must
have a name of the form `NB_NAME`, where `NB` is the (unique) mission number
and `NAME` is a mission name (typically referring to a command name).

Note that the mission number `NB` influences the order in which the mission
will be played (missions with smaller numbers are played first).

A mission will typically have the following directory structure (most of these
files are optional):
```
missions/NB_NAME
├── bashrc
├── deps.sh
├── static.sh
├── goal.sh / goal.txt
├── init.sh
├── auto.sh
├── check.sh
├── treasure.sh
├── treasure-msg.sh / treasure.txt
├── bin
│   ├── my_program
│   └── ...
└── i18n
    ├── template
    ├── en.po
    ├── fr.po
    ├── ...
    ├── goal
    │   ├── en.txt
    │   ├── fr.txt
    │   └── ...
    └── treasure-msg
        ├── en.txt
        ├── fr.txt
        └── ...
```

### `bashrc` (optional)

This file is added to the global configuration of the bash session used during
the game. It can be used to define, e.g., variables, aliases, functions. They
will be available throughout the game.

### `deps.sh` (optional)

This shell program is ran (with `bash deps.sh`) at **mission startup**. It is
used to check that the dependencies for the mission are met (e.g., that every
necessary command is available on the system).

The script is expected to end with either:
- a command returning 0 (e.g., `true`) to indicate that dependencies are met,
- a command returning 1 (e.g., `false`) to indicate that they are not met.

If the dependencies are met the program should have no output. However, if the
dependencies are not met then an helpful error message should be displayed.

### `static.sh` (mandatory)

This file is read by bash on **GameShell startup**. It can be used to set up
the directory structure in the mission, and to install other static files.

The script can make use of the following variables:
- `$MISSION_DIR` containing an absolute path to the mission directory.
- `$GSH_HOME` containing an absolute path to the GameShell home directory.

Note that this file is read by bash (with `source static.sh`) so it can create
environment variables.

### `goal.sh` / `goal.txt` (mandatory)

The file `goal.sh` is read by bash (with `source goal.sh`) whenever the player
runs `gsh show`. It is intended to display the mission instructions.

As an alternative it is possible to only provide a file `goal.txt` which is
simply displayed (with `cat goal.txt`) on `gsh show`. This option should be
avoided if you plan to internationalise your mission.

### `init.sh` (optional)

This file is read by bash at **mission startup** and it is typically used to
(re-)generate dynamic parts of the mission.

Note that this file is read by bash (with `source static.sh`) so it can create
environment variables.

### `auto.sh` (optional)

This file is read by bash (with `source auto.sh`) to automatically validate a
mission. In other words, the commands in this file should perform whatever are
the necessary actions to complete the mission.

### `check.sh` (mandatory)

This file is read by bash (with `source check.sh`) on `gsh check` to validate
the mission. It must be terminated by a command returning 0 (typically `true`)
in case of success, and by a command returning 1 (typically `false`) in case
of failure. In case of failure an explanation message is expected.

### `treasure.sh` (optional)

This file is read by bash (with `source treasure.sh`) after the mission has
been successfully validated (with `gsh check`). It can be used to add new
features as rewards to certain missions.

Note that the file is also added to the global configuration of the bash so
that the reward is still available when you restart the game. As a consequence
there should be no output.

### `treasure-msg.sh` / `treasure.txt` (optional)

These files are similar to `goal.sh` / `goal.txt` but they are ran / displayed
after the mission has been completed. It can be used to inform the player that
a treasure (i.e., a feature installed by `treasure.sh`) has been won.

### `bin/` (optional)

Directory containing executable files that can be used during the game. The
files in this directory are made available in the global `PATH`.

### `i18n/` (optional)

Directory containing files related to [internationalisation](i18n.md)
