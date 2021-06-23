#!/bin/sh

case "$GSH_SHELL" in
  *bash)
    export PS1='
\w
[mission $(gsh pcm)] $ '
    ;;
  *zsh)
    export PS1='
%~
[mission $(gsh pcm)] $ '
    ;;
esac
