#!/bin/sh

WD=$(dirname $0)
cd $WD/../..
tar cvf gash.tar --exclude=auto.sh GameShell/start.sh GameShell/bin GameShell/missions GameShell/lib


# TODO
# generate archive with given missions
# generate archive with given admin passwd
# generate archive with / without "auto.sh" scripts
