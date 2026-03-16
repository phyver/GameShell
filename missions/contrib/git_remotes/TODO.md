
  - [ ] clarify and experiments with local remotes (see below)
  - [ ] `git clone`
  - [ ] `git push`
  - [ ] `git pull` and / or `git fetch`
  - [ ] ??? `git remote show` ???
  - [ ] ??? adding / removing remotes ??? (in most cases, the remotes is configured automatically when using a remote branch...)


Local remotes could be used instead of remote gitlab / github repositories.

  - We could use a bare repository inside Gameshell that is cloned in a
    strange path, where the parent directory without rwx permissions. (players
    cannot really "go there"
  - Those repo apparently don't need the r permission but require the x
    permission (otherwise, cloning is not possible).
  - If we don't want player to push there, they don't need the w permission.

We could define an environment variable so that cloning such a repo doesn't
"feel" like cloning a local directory. (Not sure this is worth it...)
