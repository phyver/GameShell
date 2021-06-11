# this script should be **sourced**
# it will output the current environment: names of variables, functions,
# aliases and processes

{
  ## get alias names
  # for bash
  # compgen -a          | sed 's/^/Alias:/'
  # or
  alias | sed -e 's/^alias *//' -e 's/=.*//' -e 's/^/Alias:/'

  ## get variable names
  # for bash
  # compgen -v          | sed 's/^/Variable:/'
  # or, for both bash and zsh
  [ -n "$BASH_VERSION" ] && set -o posix
  set | sed -e 's/=.*//' -e 's/^/Variable:/'
  [ -n "$BASH_VERSION" ] && set +o posix

  ## get function names
  # for bash
  compgen -A function | sed 's/^/Function:/'
  # for zsh
  # print -l ${(ok)functions}

  ## get processes
  ps -o pid,comm      | sed '1d;s/^/Process:/'

  ## get working directory
  pwd                 | sed 's/^/PWD:/'

} | grep -vE "grep|ps|sed|sort|bash|zsh" | sort
