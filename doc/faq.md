(Frequently?) Asked Questions about GameShell
=============================================

-----------------------------

Q. What languages are supported in GameShell?

A. At the moment, GameShell can only be played in English, and French. You are
of course welcome to contribute other translations. ([internationalisation /
translation manual](./i18n.md))

-----------------------------

Q. How can you change the language used by GameShell?

A. GameShell uses the locale to choose the language. More precisely, the
language depends on the `LC_MESSAGES` variable.

On GNU systems, you can use the `LANGUAGE` variable to give a list of
languages you want, by order of preference. You can set this variable with
the `-L` option when running GameShell:
```sh
$ ./gameshell.sh -L fr:it:en
```

Non GNU systems (including macOS) don't use the `LANGUAGE` variable. You
thus need to set the `LC_MESSAGES` variable to a valid locale:
```sh
$ LC_MESSAGES=fr_FR.utf8 ./gameshell.sh -L fr:it:en
```
You can get a list of valid locales on your system with
```sh
$ locale -a
```

-----------------------------

Q. What shells are supported by GameShell?

A. Currently, we only support bash and zsh. By default, GameShell uses the
value of the `SHELL` environment variable to decide which one to choose.
If this variable is neither `zsh` nor `bash`, GameShell defaults to using
bash.

You can force bash with option `-B` and zsh with option `-Z`.

Using zsh is still a new addition, so don't hesitate to give us feedback.


-----------------------------

Q. Can I use GameShell in the classroom?

A. Of course! GameShell was initially developed for this very reason.

Note that you can create your own GameShell archives with the missions you
want using the `GSH_ROOT/utils/archive.sh` script. You should probably

 - choose a password different from the default `gsh` (option `-p ...`)
 - activate the "passport" mode by default (option `-P`). The only
   difference is that GameShell will ask for the player's name and email
   on startup. Those informations are saved in the file
   `$GSH_ROOT/.config/passort.txt`. (I use it both for making evaluating
   the students easier, but also so that they realize their game is tied
   to them.)

-----------------------------

Q. On what plaftorms does GameShell run?

A. GameShell is developed on Linux (Debian and Archlinux) and should run on
any GNU-linux distribution.

We aim for portability on most POSIX systems, and it is tested regularly on
freebsd and openbsd.

We don't ourselves use macOS, but we use Github facilities to run some
automatic tests on this platform. Problems with running GameShell on macOS
should be reported as bugs.

We haven't tried using GameShell on Windows + POSIX (Cygwin?) but would love
to hear from you if you try.

-----------------------------

