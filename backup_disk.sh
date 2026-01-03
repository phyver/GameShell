#!/usr/bin/bash 
ID_MISSION=$1

mkdir -p "/var/www/html/GameShell/missions/lvm/00_shared/data/$ID_MISSION/"

umount /dev/esdea/ouskelcoule
umount /dev/esdea/douskelpar
umount /dev/esdebe/grandflac

lvchange -an /dev/esdea/ouskelcoule
lvchange -an /dev/esdea/douskelpar
lvchange -an /dev/esdebe/grandflac

vgchange -an esdea
vgchange -an esdebe
vgchange -an esdece

vgexport esdea
vgexport esdebe
vgexport esdece

zip -jr /var/www/html/GameShell/missions/lvm/00_shared/data/$ID_MISSION/disks.zip /var/www/html/GameShell/missions/lvm/00_shared/data/00/disk*.img
