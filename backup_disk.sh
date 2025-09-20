#!/usr/bin/bash 
ID_MISSION=$1

vgchange -an esdea
vgchange -an esdebe
vgchange -an esdece

zip -jr /var/www/html/GameShell/missions/lvm/00_shared/data/$ID_MISSION/disks.zip /var/www/html/GameShell/missions/lvm/00_shared/data/00/disk*.img
