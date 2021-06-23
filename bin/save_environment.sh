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
  if [ -n "$BASH_VERSION" ]
  then
    compgen -v          | sed 's/^/Variable:/'
  else
  # elif  [ -n "$ZSH_VERSION" ]
  # then
    set | sed -e 's/=.*//' -e 's/^/Variable:/'
  fi

  ## get function names
  if [ -n "$BASH_VERSION" ]
  then
    compgen -A function | sed 's/^/Function:/'
  elif  [ -n "$ZSH_VERSION" ]
  then
    print -l ${(ok)functions} | sed 's/^/Function:/'
  fi

  ## get processes
  ps -o pid,comm      | sed '1d;s/^/Process:/'

  ## get working directory
  pwd                 | sed 's/^/PWD:/'

} | grep -vE "grep|ps|sed|sort|bash|zsh" | sort
