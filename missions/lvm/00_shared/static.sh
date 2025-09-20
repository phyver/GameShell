# #!/usr/bin/env sh

# DISK_1_PATH="$MISSION_DIR/data/disk1.img"
# DISK_2_PATH="$MISSION_DIR/data/disk2.img"

# # 1. Créer les fichiers images des disques de 100mo chacun
# if ! [ -d "$MISSION_DIR/data" ]; then
#     mkdir -p "$MISSION_DIR/data"
# fi

# if [ -e "$DISK_1_PATH" ] || [ -e "$DISK_2_PATH" ]; then
#     echo "Disk image files already exist. Skipping creation."
#     return 0

# else
#     echo "Creating disk image files..."
#     dd if=/dev/zero of="$DISK_1_PATH" bs=1M count=60
#     dd if=/dev/zero of="$DISK_2_PATH" bs=1M count=40
# fi  

# # 2. Attacher les fichiers images à des périphériques loop si pas encore fait
# if ! sudo losetup -j "$DISK_1_PATH" | grep -q "$DISK_1_PATH"; then
#     echo "⏳ Attaching $DISK_1_PATH to a loop device..."
#     LOOP1=$(sudo losetup --find --show "$DISK_1_PATH")
# else
#     echo "$DISK_1_PATH is already attached to a loop device."
#     LOOP1=$(sudo losetup -j "$DISK_1_PATH" | cut -d: -f1)
# fi

# if ! sudo losetup -j "$DISK_2_PATH" | grep -q "$DISK_2_PATH"; then
#     echo "⏳ Attaching $DISK_2_PATH to a loop device..."
#     LOOP2=$(sudo losetup --find --show "$DISK_2_PATH")
# else
#     echo "$DISK_2_PATH is already attached to a loop device."
#     LOOP2=$(sudo losetup -j "$DISK_2_PATH" | cut -d: -f1)
# fi

# echo "$DISK_1_PATH attached to $LOOP1"
# echo "$DISK_2_PATH attached to $LOOP2"

# # 3. Créer les alias dans /dev
# sudo ln -sf "$LOOP1" /dev/gsh_lvm_loop1
# sudo ln -sf "$LOOP2" /dev/gsh_lvm_loop2