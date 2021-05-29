Running GameShell (to integrate in the user manual?)
----------------------------------------------------

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

This is the easiest way to distribute GameShell to a group of students. Once you've
cloned the repository, create an executable archive with the `archive.sh` script:

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
