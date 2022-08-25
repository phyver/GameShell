GameShell user manual
=====================


Starting a game
---------------

To start playing you need to download either a pre-built executable archive
(found on the [releases page](https://github.com/phyver/GameShell/releases))
or the source code of the game.

### Using an executable archive

The easiest way to start the game is to run a self-extracting executable
archive (see the end of this page to know how to generate one yourself).
Pre-built archives for the various versions of the game can be found on the
[releases page](https://github.com/phyver/GameShell/releases).

To download and start the latest version of the game simply run the following
two commands in a terminal.
```sh
$ wget https://github.com/phyver/GameShell/releases/download/latest/gameshell.sh
$ bash gameshell.sh
```

Note that when you quit the game (with `control-d` or the command `gsh exit`)
your progression will be saved in a new archive (called `gameshell-save.sh`).
It can be run to resume the game where you left it.

### Using the start script in the source code

Alternatively, you can run the game directly from the source code. In that
case, simply download the repository (either by cloning it or by downloading
a tarball) and start the game with the following commands:
```sh
$ git clone https://github.com/phyver/GameShell.git
$ bash GameShell/start.sh
```

### Available flags

You should not need to change the default options for the scripts, but you
can see a list of available options using the `-h` flag.


Playing GameShell, standard commands
------------------------------------

Playing GameShell involves very few game-specific commands. They are

* `gsh goal`: displays the current mission's goal. If the goal doesn't fit on
  the screen, it is paginated with the `less` or `more` command.

* `gsh check`: checks if the current mission is completed. If so, a
  congratulation message is displayed, and the player starts the next mission.
  If not, the mission is reset.
  A player can run `gsh check` as many times as she wants.

* `gsh reset`: if the player messed up the mission by removing an important
  file, this command will try to reset the mission, without checking for
  completion first.
  In rare cases, `gsh hardreset` might be necessary.

* `gsh help`: displays a small message with this very information.


The command `gsh exit` will quit the current game, but it is customary to use
the sequence `Control-d` for the same purpose.



Playing GameShell, other commands
---------------------------------

In some situations, some other commands are needed. They are described by the
`gsh HELP` command. Here are the main ones.

* `gsh skip`: it has unfortunately happened that some bug prevented a mission
  to be completed successfully. The command `gsh skip` will cancel the
  current mission and go to the next one. Running this command will first ask
  for a password (except in debug mode) to avoid students overusing it. (Just
  like most other `gsh` commands, the use of this command is logged.)
  Note however that skiping a mission that has already been completed doesn't
  require a password.

* `gsh goto N`: when the previous command isn't sufficient, `gsh goto N`
  which will go directly to mission `N`. Just like `gsh skip`, this command
  will first ask for a password.
  Note however that going back to a previous mission doesn't require a
  password.

* `gsh protect` and `gsh unprotect`: the directories containing GameShell code
  and data are neither readable nor writable by the player. (Except in debug
  mode, or when running from the source repository.) That's to prevent
  accident where a player inadvertently removes some important file. Those
  commands reset the read / write permissions.

* `gsh auto`: if the mission comes with an automatic script (`auto.sh`), this
  command will call it. This script is supposed to complete the mission and
  call `gsh check`.
  This is useful for testing purposes, but also if using `gsh skip` is not
  sufficient. For example, if the mission's goal is to create a directory.
  `gsh auto` would ensure it is created correctly.
  Just like `gsh skip` and `gsh goto N`, this command will first ask for a
  password.

* `gsh index`: this will display the list of available missions, with their
  status. If you've used `skip` and `goto` a lot, this might come in handy.

* `gsh stat`, `gsh stat raw` and `gsh stat raw -v` display various statistics
  about the current game.

The other commands are either self-explanatory (`gsh welcome`) or only useful
while creating missions (`gsh assert ...`, `gsh test`).



Creating an executable archive
------------------------------

The script `utils/archive.sh` is used to create an executable archive to
distribute a (customized) version of GameShell.

By default, it creates an archive with all the missions listed in the
`$GSH_ROOT/missions/index.txt` file and with all the available translations.
You can choose the missions you want by listing them on the command line:
```sh
$ ./utils/archive.sh missions/basic/01_cd_tower missions/basic/02_cd.._cellar/ missions/basic/03_cd_HOME_throne/
```
If a directory contains an `index.txt` file, all the missions listed in it
will be included. You can also give an `index.txt` file directly on the
command line.

You can customize the archive with the following options

* `-A` : make the archive default to the "anonymous" mode. This is the
  default.
* `-P` : make the archive default to the "passport" mode. For each new game,
  GameShell will ask for the player's name and email. This is useful in the
  classroom as it makes it easier to link a game to the corresponding student.
  (The player can run the archive in anonymous mode with the `-A` option.)
* `--password PASSWORD`: you can choose the admin password for the archive.
  This is also useful in the classroom as we might not want the students to
  learn of this password. :)
* `-a`: keep the automatic scripts. Some missions come with a script that
  automagically completes the missions. By default, those scripts are **not**
  included in the archive. Use `-a` if you want to keep them.
* `-N NAME`: if you want the archive and its directory to be called something
  other than "GameShell", you can set the name with this option.
* `-k`: keep the GameShell archive. The compressed `tar` archive is appended
  to a shell script to create the executable archive. With this option, you
  can keep the "standard" `tar` archive as well as the executable one.
