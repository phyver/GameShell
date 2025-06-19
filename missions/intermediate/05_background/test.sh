#!/usr/bin/env sh

# set -m

gsh assert check false
flarigo & gsh assert check false
flarigo & flarigo & gsh assert check false
flarigo & flarigo & flarigo & gsh assert check true
flarigo & flarigo & flarigo & flarigo & gsh assert check true

# FIXME: those should work, but don't because the gsh assert check is run in a
# subshell...
# (they do work in a real game though)
# gsh assert check true & flarigo & flarigo & flarigo
# flarigo & gsh assert check true & flarigo & flarigo
# flarigo & flarigo & gsh assert check true & flarigo

flarigo & flarigo & flarigo
gsh assert check false

flarigo; flarigo; flarigo
gsh assert check false


