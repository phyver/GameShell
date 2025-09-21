#!/usr/bin/env sh

# Unmount filesystems to allow merging
danger sudo umount Esdea/Douskelpar/
danger sudo umount Esdea/Ouskelcoule/
danger sudo umount Esdebe/Grandflac/

# Rename the volume group Esdea to USA
danger sudo vgrename esdea usa

# Merge the volume group Esdebe into USA
danger sudo lvchange -an esdebe/grandflac_snap
danger sudo lvremove -yf esdebe/grandflac_snap

danger sudo vgchange -an usa
danger sudo vgmerge -y usa esdebe

# Activate the logical volumes in the merged volume group
danger sudo vgchange -ay usa


