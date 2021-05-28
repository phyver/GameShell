GameShell: a "game" to learn the Unix shell
===========================================

![Illustration inspired by the game](art/illustration-small.png)

GameShell (gsh) is the outcome of thinking how to best teach the basics (and
slightly more) of using a shell to first year students at the université
Savoie Mont Blanc.

The original idea, due to Rodolphe Lepigre, was to run a standard bash session
with an appropriate configuration file that defined "missions" which would be
"checked" in order to advance in the game.

Here is the result...

Do not hesitate to send us you remarks, questions or suggestions about
GameShell. We are particularly interested in any new mission you might create!


GameShell released under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html)


NOTE
====

GameShell is currently undergoing heavy development. The current version
hasn't been field tested by students. Don't hesitate to open issues on bug or
suggestions.


### Developpers

* Pierre Hyvernat
* Rodolphe Lepigre


### contact

Pierre Hyvernat

http://www.lama.univ-smb.fr/~hyvernat

pierre.hyvernat@univ-smb.fr




Dépendencies
------------

GameShell should (??) work on any standard Linux system. On Debian/Ubuntu, the
only dependency (besides `bash`) required to play is the package `gettext-base`.
`awk` is also required, but should be installed by default.

If you want create your own missions and translate them, you'll need the full
`gettext` package as well.

Some missions have additional dependencies. If they are not met, those
missions are ignored. To run all the currently available missions, you need
the following

  - `man` (`man-db` package in Debian/Ubuntu)
  - `ps` (`procps` package in Debian/Ubuntu)
  - `pstree` (`psmisc` package in Debian/Ubuntu)
  - `nano` (`nano` package in Debian/Ubuntu)
  - `tree` (`tree` package in Debian/Ubuntu)
  - `cal` (`bsdmainutils` package in Debian/Ubuntu)
  - `xeyes` (`x11-apps` package in Debian/Ubuntu)
  - `python3` (`python3` package in Debian/Ubuntu)

On a Debian / Ubuntu system, the following ensures you have everything you
need to run GameShell without problems.

````
    $ sudo apt install gettext-base python3 man-db psmisc nano tree bsdmainutils x11-apps gettext
````


### Other systems

#### macOS

It should be possible to run GameShell on macOS, but we don't ourselves use
macOS. Contact us if you have problems running GameShell and are willing to
help us test it.

To install the dependencies, the easiest is probably to use the package
manager [homebrew](https://brew.sh/index_fr) :

````
    $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
````

and to install the dependencies with

````
    $ brew install nano pstree tree man-db
````


#### BSD ???

We haven't tested it a lot, but it should run on freeBSD once you install the
dependencies:

````
    $ pkg install bash gettext pstree wget
````


#### Windows ???

It might be possible to run GameShell on Windows, if you have installed
[Cygwin](https://www.cygwin.com/).

We haven't tried but are interested in any feedback.



Running GameShell
-----------------

### 1/ from the source directory

Download the archive and run the `start.sh` script:

    $ rm -rf GameShell && mkdir GameShell && wget  https://api.github.com/repos/phyver/GameShell/tarball -O -  |  tar -xz -C GameShell --strip-components 1
    $ ./GameShell/start.sh
    ...
    ...

If your `tar` version doesn't have the option `--strip-components`, use the
following:

    $ rm -rf phyver-GameShell-* && wget  https://api.github.com/repos/phyver/GameShell/tarball -O -  |  tar -xz
    $ ./phyver-GameShell-*/start.sh
    ...
    ...


### 2/ from the git repository

First clone the repository, and run the `start.sh` script

    $ git clone https://github.com/phyver/GameShell.git
    $ ./GameShell/start.sh
    ...
    ...


### 3/ from an executable archive

That's the easiest to distribute GameShell to a group of students. Once you've
cloned the repository, create an executable archive with the `archive.sh`
script:

    $ cd GameShell
    $ ./utils/archive.sh
    copy missions
    01_cd_1  -->  000001_cd_1
    ...
    ...
    generating '.mo' files
    removing 'auto.sh' scripts
    removing unnecessary (_*.sh, Makefile) files
    setting admin password
    setting default GameShell mode
    creating archive
    creating self-extracting archive
    removing tgz archive
    removing temporary directory
    $ ls
    ... GameShell.sh ...

The `GameShell.sh` file contains an instance of GameShell that you can easily
copy to any other computer. To run it, you can either use

    $ ./GameShell.sh

or

    $ bash ./GameShell.sh


### 4/ from a Docker container

The idea behind GameShell is to be "as close as possible" to a standard shell
session. For that reason, I use it on "standard" Linux computers, or on a
virtual machine running Linux.

If you prefer, you can run it from a Docker image. The `Dockerfile`
included in the repository will create a Docker image with all the
dependencies.

* create the image (from the GameShell repository)

        $ docker build -t gsh .

* run the image, if you have an X server:

        $ host +"local:docker@" &&    \
          docker run -it              \
             -e DISPLAY=${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix \
             gsh

* run the image, without an X server:

        $ docker run -it gsh


Basic commands
--------------

GameShell is just a bash session with additional commands. You can run them
with the `gsh` command:

  - `gsh help` : show a list of available commands
  - `gsh goal` : show the goal of the current mission
  - `gsh check` : check if the current mission has been completed
  - `gsh reset` : reset the current mission

Some other commands exist but shouldn't be necessary in a standard game. You
can get the full list with

  - `gsh HELP` : show a full list of `gsh` commands

Those commands are explained in details in the file `doc/gameshell.md`.


Adding missions
---------------

Creating new missions is explained in a dedicated file `doc/missions.md`.



Missions contributors
---------------------

* Pierre Hyvernat
* Rodolphe Lepigre
* Christophe Raffalli
* Xavier Provencal
* Clovis Eberhart
* Sébastien Tavenas
* Tiemen Duvillard


Special thanks
--------------

* All my students who discovered many bugs in the early versions
* Joan Stark, who designed hundreds of ASCII-art pieces in the late 90'. Most
  of the ASCII-art you encounter in GameShell are due to her. (That's the
  meaning of the "`jgs`" initials you'll see there.)


Licence
-------

GameShell released under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html)

Please link to this repository if you use GameShell.
