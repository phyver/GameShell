#!/bin/bash

# this script should be **sourced**
# it will output the current environment: names of variables, functions,
# aliases and processes

{
  compgen -v          | sed 's/^/Variable:/'
  compgen -A function | sed 's/^/Function:/'
  compgen -a          | sed 's/^/Alias:/'
  ps -o pid,comm      | sed '1d;s/^/Process:/'
  pwd                 | sed 's/^/PWD:/'
} | grep -vE "grep|ps|sed|sort|bash" | sort

