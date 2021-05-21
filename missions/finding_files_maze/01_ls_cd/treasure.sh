# NOTE: --literal doesn't exist in freebsd
#       --color doesn't exist in macos
if ls --literal / &> /dev/null
then
  if ls --color=auto / &> /dev/null
  then
    alias ls='ls --literal -p --color=auto'
  else
    alias ls='ls --literal -p -G'
  fi
else
  if ls --color=auto / &> /dev/null
  then
    alias ls='ls -p --color=auto'
  else
    alias ls='ls -p -G'
  fi
fi
