#!/usr/bin/env sh

# set -m

gsh assert check false
flarigo & gsh assert check false
flarigo & flarigo & gsh assert check false
flarigo & flarigo & flarigo & gsh assert check true
flarigo & flarigo & flarigo & flarigo & gsh assert check true

flarigo & flarigo & flarigo
gsh assert check false

flarigo; flarigo; flarigo
gsh assert check false


