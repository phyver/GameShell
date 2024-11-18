#!/usr/bin/env sh

# set -m

gsh assert check false
charmiglio & gsh assert check false
charmiglio & charmiglio & gsh assert check false
charmiglio & charmiglio & charmiglio & gsh assert check true
charmiglio & charmiglio & charmiglio & charmiglio & gsh assert check true

charmiglio & charmiglio & charmiglio
gsh assert check false

charmiglio; charmiglio; charmiglio
gsh assert check false


