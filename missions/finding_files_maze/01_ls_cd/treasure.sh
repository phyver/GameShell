#!/bin/sh

# NOTE: --literal doesn't exist in freebsd
#       --color doesn't exist in macos, it is replaced by -G
#       colors do not exist in openbsd!
#
if ls --literal >/dev/null 2>/dev/null
then
  if ls --color=auto >/dev/null 2>/dev/null
  then
    alias ls='ls --literal -p --color=auto'
  elif ls -G >/dev/null 2>/dev/null
  then
    alias ls='ls --literal -p -G'
  fi
else
  if ls --color=auto >/dev/null 2>/dev/null
  then
    export COLORTERM=1  # necessary for freeBSD
    alias ls='ls -p --color=auto'
  elif ls -G / >/dev/null 2>/dev/null
  then
    alias ls='ls -p -G'
  fi
fi
