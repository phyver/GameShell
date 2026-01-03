#!/usr/bin/env sh

danger sudo lvcreate -L 5M -s -n ouskelcoule_snap /dev/esdea/ouskelcoule
danger sudo lvcreate -L 5M -s -n douskelpar_snap /dev/esdea/douskelpar
danger sudo lvcreate -L 5M -s -n grandflac_snap /dev/esdebe/grandflac
