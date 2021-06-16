# this script should be **sourced**
# it will output the current environment: names of variables, functions,
# aliases and processes

{
  # compgen -a          | sed 's/^/Alias:/'
  alias | sed -e 's/^alias *//' -e 's/=.*//' -e 's/^/Alias:/'

  # compgen -A function | sed 's/^/Function:/'

  ps -o pid,comm      | sed '1d;s/^/Process:/'
  pwd                 | sed 's/^/PWD:/'

  # compgen -v          | sed 's/^/Variable:/'
  [ -n "$BASH_VERSION" ] && set -o posix
  set | sed -e 's/=.*//' -e 's/^/Variable:/'
  [ -n "$BASH_VERSION" ] && set +o posix

} | grep -vE "grep|ps|sed|sort|bash|zsh" | sort

