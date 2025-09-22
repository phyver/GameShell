#!/usr/bin/env sh

# Increase the size of ouskelcoule to 40M
danger sudo lvextend -L 40M /dev/esdea/ouskelcoule
danger sudo resize2fs /dev/esdea/ouskelcoule

# Decrease the size of douskelpar to 10M
danger sudo umount /dev/esdea/douskelpar
danger sudo e2fsck -y -f /dev/esdea/douskelpar
danger sudo lvchange -an /dev/esdea/douskelpar
danger sudo resize2fs -M /dev/esdea/douskelpar
danger sudo lvreduce --yes -L 10M /dev/esdea/douskelpar
danger sudo lvchange -ay /dev/esdea/douskelpar
danger sudo resize2fs /dev/esdea/douskelpar
danger sudo mount /dev/esdea/douskelpar "$GSH_HOME/Esdea/Douskelpar"
danger sudo chown -R "$USER:$USER" "$GSH_HOME/Esdea/Douskelpar"

