GameShell: a "game" to teach the Unix shell
===========================================

![Illustration inspired by the game](art/illustration-small.png)

Teaching first-year university students or high schoolers to use a Unix shell
is not always the easiest or most entertaining of tasks. GameShell was devised
as a tool to help students at the
[Université Savoie Mont Blanc](https://univ-smb.fr) to engage with a *real*
shell, in a way that encourages learning while also having fun. 

The original idea, due to Rodolphe Lepigre, was to run a standard bash session
with an appropriate configuration file that defined "missions" which would be
"checked" in order to progress through the game.

Here is the result...

Feel free to send us your remarks, questions or suggestions by opening
[issues](https://github.com/phyver/GameShell/issues) or submitting
[pull requests](https://github.com/phyver/GameShell/pulls).
We are particularly interested in any new missions you might create!


Getting started
---------------

**Note:** GameShell is currently undergoing heavy development: the current
version has not been field tested by students. Do not hesitate to report any
problems you might encounter or suggestions you might have by
[opening an issue](https://github.com/phyver/GameShell/issues/new).

GameShell should work on any standard Linux system, and also on macOS and BSD
(but we have run fewer tests on the latter systems). On Debian or Ubuntu, the
only dependencies (besides `bash`) are the `gettext-base` and `awk` packages
(the latter is generally installed by default). Some missions have additional
dependencies: these missions will be skipped if the dependencies are not met.
On Debian or Ubuntu, run the following command to install all game and mission
dependencies.
```sh
$ sudo apt install gettext man-db psmisc nano tree bsdmainutils x11-apps wget
```
Check the [user manual](doc/user_manual.md) to see how to install the game
dependencies on other systems (macOS, BSD, ...).

Assuming all the dependencies are installed, you can try the latest version of
the game by running the following two commands in a terminal.
```sh
$ wget https://github.com/phyver/GameShell/releases/download/latest/gameshell.sh
$ bash gameshell.sh
```
The first command will download the latest version of the game in the form of
a self-extracting archive, and the second command will initialise and run the
game from the downloaded archive. Instructions on how to play are provided in
the game directly.

Note that when you quit the game (with `control-d` or the command `gsh exit`)
your progression will be saved in a new archive (called `GameShell-save.sh`).
Run this archive to resume the game where you left it.


Documentation
-------------

To find out more about GameShell, refer to the following documents:
- The [user manual](doc/user_manual.md) provides information on how to run the
  game on all supported platforms (Linux, macOS, BSD), explains how to run the
  game from the sources, tells you how to generate custom game archives (which
  is useful if you want to use GameShell for teaching a class), and more.
- The [developer manual](doc/dev_manual.md) provides information on how to
  create new missions, how to translate missions, and how to participate
  in the development of the game.


Who is developing GameShell?
----------------------------

### Developers

The game is currently being developed by:
* [Pierre Hyvernat](http://www.lama.univ-smb.fr/~hyvernat) (main developer,
  [pierre.hyvernat@univ-smb.fr](mailto:pierre.hyvernat@univ-smb.fr)),
* [Rodolphe Lepigre](https://lepigre.fr).

### Mission contributors

* Pierre Hyvernat
* Rodolphe Lepigre
* Christophe Raffalli
* Xavier Provencal
* Clovis Eberhart
* Sébastien Tavenas
* Tiemen Duvillard

### Special thanks

* All the students who found *many* bugs in the early versions.
* Joan Stark (a.k.a, jgs), who designed hundreds of ASCII-art pieces in the
  late 90s. Most of the ASCII-art encountered in GameShell are due to her.


Licence
-------

GameShell is released under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html).

Please link to this repository if you use GameShell.
