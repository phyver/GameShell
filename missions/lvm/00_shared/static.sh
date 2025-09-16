#!/usr/bin/env sh

mkdir -p "$GSH_HOME/dev"

# disques de 100mo chacun
DISK_1_PATH="$MISSION_DIR/data/disk1.img"
DISK_2_PATH="$MISSION_DIR/data/disk2.img"

dd if=/dev/zero of="$DISK_1_PATH" bs=1M count=100
dd if=/dev/zero of="$DISK_2_PATH" bs=1M count=100

# 2. Attacher les fichiers images à des périphériques loop
LOOP1=$(sudo losetup --find --show "$DISK_1_PATH")
LOOP2=$(sudo losetup --find --show "$DISK_2_PATH")

echo "Disk1 attached to $LOOP1"
echo "Disk2 attached to $LOOP2"

# 3. Créer les alias dans /dev
sudo ln -sf "$LOOP1" /dev/gsh_lvm_loop1
sudo ln -sf "$LOOP2" /dev/gsh_lvm_loop2