#!/bin/sh

WD=$(dirname $0)
cd $WD/../..
tar cvf gash.tar GameShell/bin GameShell/config GameShell/missions GameShell/lib GameShell/doc


# TODO
# generate archive with given missions
# generate archive with given admin passwd
# generate archive with / without "auto.sh" scripts
