
lvm_init() {
    MISSION_ID=$1
    DATA_PATH="$MISSION_DIR/../00_shared/data/00/"
    MISSION_DATA_PATH="$MISSION_DIR/../00_shared/data/$MISSION_ID/"

    if ! [ -e "$DATA_PATH" ]
    then
        DUMMY_MISSION=$(missionname "$MISSION_DIR/../00_shared/")
        echo "$(eval_gettext "Dummy mission '\$DUMMY_MISSION' is required for mission \$MISSION_NB (\$MISSION_NAME).")" >&2
        unset DUMMY_MISSION
        return 1
    fi
  
    # 1. unzip the disk images
    echo "📦 Unzipping discs..."
    echo "    unzip -o "$MISSION_DATA_PATH/disks.zip" -d "$DATA_PATH/""
    unzip -o "$MISSION_DATA_PATH/disks.zip" -d "$DATA_PATH"
  
    DISK_1_PATH="$DATA_PATH/disk1.img"
    DISK_2_PATH="$DATA_PATH/disk2.img"
  
    # 2. Attacher les fichiers images à des périphériques loop si pas encore fait
    if ! danger sudo losetup -j "$DISK_1_PATH" | grep -q "$DISK_1_PATH"; then
        echo "⏳ Attaching $DISK_1_PATH to a loop device..."
        LOOP1=$(danger sudo losetup --find -P --show "$DISK_1_PATH")
        echo "$DISK_1_PATH attached to $LOOP1"
    else
        echo "$DISK_1_PATH is already attached to a loop device."
        LOOP1=$(danger sudo losetup -j "$DISK_1_PATH" | cut -d: -f1)
    fi
  
    if ! danger sudo losetup -j "$DISK_2_PATH" | grep -q "$DISK_2_PATH"; then
        echo "⏳ Attaching $DISK_2_PATH to a loop device..."
        LOOP2=$(danger sudo losetup --find -P --show "$DISK_2_PATH")
        echo "$DISK_2_PATH attached to $LOOP2"
    else
        echo "$DISK_2_PATH is already attached to a loop device."
        LOOP2=$(danger sudo losetup -j "$DISK_2_PATH" | cut -d: -f1)
    fi
  
    # 3. Créer les alias dans /dev
    danger sudo ln -sf "$LOOP1" /dev/gsh_lvm_loop1
    danger sudo ln -sf "$LOOP2" /dev/gsh_lvm_loop2
  
    # 4. Préparer les périphériques dans world/dev
    mkdir -p "$GSH_HOME/dev"
  
    LOOP1_PATH="/dev/gsh_lvm_loop1"
    LOOP2_PATH="/dev/gsh_lvm_loop2"
  
    if ! [ -e "$LOOP1_PATH" ] || ! [ -e "$LOOP2_PATH" ]
    then
        echo "$(eval_gettext "Loop devices \$LOOP1_PATH and \$LOOP2_PATH are required for mission \$MISSION_NB (\$MISSION_NAME).")" >&2
        return 1
    fi
  
    # prepare world/dev
    echo "Preparing world/dev..."
    SDBA="$GSH_HOME/dev/sda"
    SDBB="$GSH_HOME/dev/sdb"
    ln -sf "$LOOP1_PATH" "$SDBA"
    ln -sf "$LOOP2_PATH" "$SDBB"
  
    echo "world/dev ready"
    return 0
}

# Purge a given VG (remove all LVs, then the VG, then wipe its PVs).
# Usage: purge_vg <VGNAME>
purge_vg() {
    local VG="$1"

    # check VG exists
    if ! danger sudo vgs --noheadings -o vg_name 2>/dev/null | awk '{print $1}' | grep -qx "$VG"; then
        echo "VG '$VG' not found."
        return 0
    fi

    echo "==> Purging VG: $VG"

    # capture PVs belonging to this VG (before removal)
    local PVS=()
    mapfile -t PVS < <(
        danger sudo pvs --noheadings --separator '|' -o pv_name,vg_name 2>/dev/null \
        | sed 's/^ *//; s/ *$//' \
        | awk -F'|' -v vg="$VG" '$2==vg{gsub(/^ +| +$/,"",$1); print $1}'
    )

    # deactivate and remove all LVs in the VG (best effort)
    lvchange -an "$VG" || true
    local LVS=()
    mapfile -t LVS < <(danger sudo lvs --noheadings -o lv_path "$VG" 2>/dev/null | awk '{print $1}')
    for LV in "${LVS[@]}"; do
        echo "  - Removing LV: $LV"
        danger sudo lvremove -fy "$LV" || true
    done

    # drop missing PVs (if any) then remove VG
    danger sudo vgreduce --removemissing -f "$VG" || true
    echo "  - Removing VG: $VG"
    danger sudo vgremove -ff "$VG"

    # wipe PV metadata
    for PV in "${PVS[@]}"; do
        echo "  - Wiping PV metadata: $PV"
        danger sudo pvremove -ff -y "$PV" || true
    done

    echo "Done purging VG: $VG"
}


lvm_cleanup() {
    MISSION_ID=$1

    DATA_PATH="$MISSION_DIR/../00_shared/data/00/"
    MISSION_DATA_PATH="$MISSION_DIR/../00_shared/data/$MISSION_ID/"
    
    # If vgs esdea exist, purge it
    echo "Cleaning up LVM configurations... esdea"
    if danger sudo vgs --noheadings -o vg_name 2>/dev/null | awk '{print $1}' | grep -qx "esdea"; then
        purge_vg "esdea"
    fi

    # If vgs esdebe exist, purge it
    echo "Cleaning up LVM configurations... esdebe"
    if danger sudo vgs --noheadings -o vg_name 2>/dev/null | awk '{print $1}' | grep -qx "esdebe"; then
        purge_vg "esdebe"
    fi

    # If vgs esdece exist, purge it
    echo "Cleaning up LVM configurations... esdece"
    if danger sudo vgs --noheadings -o vg_name 2>/dev/null | awk '{print $1}' | grep -qx "esdece"; then
        purge_vg "esdece"
    fi

    # Cleanup loop devices and disk images if needed
    echo "Cleaning up loop devices and disk images..."

    # Detach loop devices
    # Get loop path from /dev/gsh_lvm_loop1 and /dev/gsh_lvm_loop2
    LOOP1=$(readlink -f /dev/gsh_lvm_loop1)
    LOOP2=$(readlink -f /dev/gsh_lvm_loop2)
    
    danger sudo losetup -d "$LOOP1" 
    danger sudo losetup -d "$LOOP2" 

    # Remove device links
    danger sudo rm -f /dev/gsh_lvm_loop1 /dev/gsh_lvm_loop2

    # Remove world/dev
    danger rm -rf "$GSH_HOME/dev/"

    # Remove disk images
    rm -f "$DATA_PATH/disk*.img"

    return 0
}