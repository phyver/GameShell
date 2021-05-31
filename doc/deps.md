Installation instructions for GameShell dependencies
====================================================

Debian / Ubuntu (and other Linux distributions)
-----------------------------------------------

GameShell should work on any standard Linux system. On Debian/Ubuntu, the
only dependencies (besides `bash`) are the package `gettext-base` and `awk`
(the latter should be installed by default).

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

```sh
$ sudo apt install gettext-base python3 man-db psmisc nano tree bsdmainutils x11-apps
```


macOS
-----

It should be possible to run GameShell on macOS, but we don't personally use
macOS. Contact us if you have problems running GameShell and are willing to
help us test it.

To install the dependencies, the easiest way is probably to use the package
manager [homebrew](https://brew.sh/index_fr) :

```sh
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

and to install the dependencies with

```sh
$ brew install nano pstree tree man-db
```


BSD
---

We haven't tested it much, but it should run on freeBSD once you install the
dependencies:

```sh
$ pkg install bash gettext pstree wget python3
```


Windows ???
-----------

It might be possible to run GameShell on Windows, if you have installed
[Cygwin](https://www.cygwin.com/).

We haven't tried but are interested in any feedback.


Running GameShell form a Docker container
-----------------------------------------

The idea behind GameShell is to be "as close as possible" to a standard shell
session. For that reason, we generally use it on "standard" Linux computers,
or on a virtual machine running Linux.

If you prefer, you can run it from a Docker image. The `Dockerfile` included
in the repository will create a Docker image with all the dependencies.

* create the image (from the GameShell repository)

        $ docker build -t gsh .

* run the image, if you have an X server:

        $ host +"local:docker@" &&    \
          docker run -it              \
             -e DISPLAY=${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix \
             gsh

* run the image, without an X server:

        $ docker run -it gsh
