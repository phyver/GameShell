
lvm_init() {

    echo "$(eval_gettext "LAST ACTION : \$LAST_ACTION")"

    # Skip initialization if last action was "check_false"
    if [ "$LAST_ACTION" == "check_false" ]; then
        echo "$(eval_gettext "Skipping initialization due to last action being 'check_false'.")"
        return 0
    fi

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
    echo "$(eval_gettext "📦 Unzipping discs...")"
    echo "$(eval_gettext "    unzip -o \"\$MISSION_DATA_PATH/disks.zip\" -d \"\$DATA_PATH/\"")"
    unzip -o "$MISSION_DATA_PATH/disks.zip" -d "$DATA_PATH"
  
    DISK_1_PATH="$DATA_PATH/disk1.img"
    DISK_2_PATH="$DATA_PATH/disk2.img"
  
    # 2. Attach image files to loop devices if not already done
    if ! danger sudo losetup -j "$DISK_1_PATH" | grep -q "$DISK_1_PATH"; then
        echo "$(eval_gettext "⏳ Attaching \$DISK_1_PATH to a loop device...")"
        LOOP1=$(danger sudo losetup --find -P --show "$DISK_1_PATH")
        echo "$(eval_gettext "\$DISK_1_PATH attached to \$LOOP1")"
    else
        echo "$(eval_gettext "\$DISK_1_PATH is already attached to a loop device.")"
        LOOP1=$(danger sudo losetup -j "$DISK_1_PATH" | cut -d: -f1)
    fi
  
    if ! danger sudo losetup -j "$DISK_2_PATH" | grep -q "$DISK_2_PATH"; then
        echo "$(eval_gettext "⏳ Attaching \$DISK_2_PATH to a loop device...")"
        LOOP2=$(danger sudo losetup --find -P --show "$DISK_2_PATH")
        echo "$(eval_gettext "\$DISK_2_PATH attached to \$LOOP2")"
    else
        echo "$(eval_gettext "\$DISK_2_PATH is already attached to a loop device.")"
        LOOP2=$(danger sudo losetup -j "$DISK_2_PATH" | cut -d: -f1)
    fi
  
    # 3. Create aliases in /dev
    danger sudo ln -sf "$LOOP1" /dev/gsh_lvm_loop1
    danger sudo ln -sf "$LOOP2" /dev/gsh_lvm_loop2
     
  
    # 4. Prepare devices in /dev  
    LOOP1_PATH="/dev/gsh_lvm_loop1"
    LOOP2_PATH="/dev/gsh_lvm_loop2"
  
    if ! [ -e "$LOOP1_PATH" ] || ! [ -e "$LOOP2_PATH" ]
    then
        echo "$(eval_gettext "Loop devices \$LOOP1_PATH and \$LOOP2_PATH are required for mission \$MISSION_NB (\$MISSION_NAME).")" >&2
        return 1
    fi
  
    # prepare world/dev
    echo "$(eval_gettext "Preparing world/dev...")"
    SDBA="/dev/gsh_sda"
    SDBB="/dev/gsh_sdb"
    danger sudo ln -sf "$LOOP1_PATH" "$SDBA"
    danger sudo ln -sf "$LOOP2_PATH" "$SDBB"

    # For mission 08, we need a third disk
    if [ "$MISSION_ID" -ge "08" ] && [ "$MISSION_ID" -lt "13" ]; then
        echo "$(eval_gettext "Preparing third disk for world/dev...")"

        DISK_3_PATH="$DATA_PATH/disk3.img"
        if ! danger sudo losetup -j "$DISK_3_PATH" | grep -q "$DISK_3_PATH"; then
            echo "$(eval_gettext "⏳ Attaching \$DISK_3_PATH to a loop device...")"
            LOOP3=$(danger sudo losetup --find -P --show "$DISK_3_PATH")
            echo "$(eval_gettext "\$DISK_3_PATH attached to \$LOOP3")"
        else
            echo "$(eval_gettext "\$DISK_3_PATH is already attached to a loop device.")"
            LOOP3=$(danger sudo losetup -j "$DISK_3_PATH" | cut -d: -f1)
        fi

        SDBC="/dev/gsh_sdc"
        LOOP3_PATH="/dev/gsh_lvm_loop3"
        danger sudo ln -sf "$LOOP3" "$LOOP3_PATH"

        danger sudo ln -sf "$LOOP3_PATH" "$SDBC"
    fi
  
    echo "$(eval_gettext "world/dev ready")"

    # if esdea VG exists activate it
    # if danger sudo vgs --noheadings -o vg_name 2>/dev/null | awk '{print $1}' | grep -qx "esdea"; then
        echo "$(eval_gettext "Activating esdea VG...")"
        danger sudo vgimport -y esdea
        danger sudo vgchange -ay esdea
    # fi

    # if esdebe VG exists activate it
    # if danger sudo vgs --noheadings -o vg_name 2>/dev/null | awk '{print $1}' | grep -qx "esdebe"; then
        echo "$(eval_gettext "Activating esdebe VG...")"
        danger sudo vgimport -y esdebe
        danger sudo vgchange -ay esdebe
    # fi

    # if esdece VG exists activate it
    # if danger sudo vgs --noheadings -o vg_name 2>/dev/null | awk '{print $1}' | grep -qx "esdece"; then
        echo "$(eval_gettext "Activating esdece VG...")"
        danger sudo vgimport -y esdece
        danger sudo vgchange -ay esdece
    # fi

    # if usa VG exists activate it
    # if danger sudo vgs --noheadings -o vg_name 2>/dev/null | awk '{print $1}' | grep -qx "usa"; then
        if [ "$MISSION_ID" != "14" ]; then
            echo "$(eval_gettext "Activating usa VG...")"
            danger sudo vgimport -y usa
            danger sudo vgchange -ay usa
        fi
    # fi

    # For missions after 05, Mount villages if possible
    if [ "$MISSION_ID" -gt 05 ]; then
        echo "$(eval_gettext "Mounting villages...")"
        mounting_villages
    fi

    return 0
}

# Purge a given VG (remove all LVs, then the VG, then wipe its PVs).
# Usage: purge_vg <VGNAME>
purge_vg() {
    local VG="$1"

    # check VG exists
    if ! danger sudo vgs --noheadings -o vg_name 2>/dev/null | awk '{print $1}' | grep -qx "$VG"; then
        echo "$(eval_gettext "VG '\$VG' not found.")"
        return 0
    fi

    echo "$(eval_gettext "==> Purging VG: \$VG")"

    # capture PVs belonging to this VG (before removal)
    local PVS=()
    mapfile -t PVS < <(
        danger sudo pvs --noheadings --separator '|' -o pv_name,vg_name 2>/dev/null \
        | sed 's/^ *//; s/ *$//' \
        | awk -F'|' -v vg="$VG" '$2==vg{gsub(/^ +| +$/,"",$1); print $1}'
    )

    # deactivate and remove all LVs in the VG (best effort)
    danger sudo lvchange -an "$VG" || true
    local LVS=()
    mapfile -t LVS < <(danger sudo lvs --noheadings -o lv_path "$VG" 2>/dev/null | awk '{print $1}')
    for LV in "${LVS[@]}"; do
        echo "$(eval_gettext "  - Removing LV: \$LV")"
        danger sudo lvremove -fy "$LV" || true
    done

    # drop missing PVs (if any) then remove VG
    danger sudo vgreduce --removemissing -f "$VG" || true
    echo "$(eval_gettext "  - Removing VG: \$VG")"
    danger sudo vgremove -ff "$VG"

    # wipe PV metadata
    for PV in "${PVS[@]}"; do
        echo "$(eval_gettext "  - Wiping PV metadata: \$PV")"
        danger sudo pvremove -ff -y "$PV" || true
    done

    echo "$(eval_gettext "Done purging VG: \$VG")"
}


lvm_cleanup() {
    MISSION_ID=$1

    echo "$(eval_gettext "GSH LAST ACTION : \$GSH_LAST_ACTION")"
    export LAST_ACTION="$GSH_LAST_ACTION"

    if [ "$LAST_ACTION" == "check_false" ]; then
        echo "$(eval_gettext "Skipping cleanup due to last action being 'check_false'.")"
        return 0
    fi

    DATA_PATH="$MISSION_DIR/../00_shared/data/00/"
    MISSION_DATA_PATH="$MISSION_DIR/../00_shared/data/$MISSION_ID/"

    # Unmount villages if mounted
    unmounting_villages
    
    # If vgs esdea exist, purge it
    echo "$(eval_gettext "Cleaning up LVM configurations... esdea")"
    if danger sudo vgs --noheadings -o vg_name 2>/dev/null | awk '{print $1}' | grep -qx "esdea"; then
        purge_vg "esdea"
    fi

    # If vgs esdebe exist, purge it
    echo "$(eval_gettext "Cleaning up LVM configurations... esdebe")"
    if danger sudo vgs --noheadings -o vg_name 2>/dev/null | awk '{print $1}' | grep -qx "esdebe"; then
        purge_vg "esdebe"
    fi

    # If vgs esdece exist, purge it
    echo "$(eval_gettext "Cleaning up LVM configurations... esdece")"
    if danger sudo vgs --noheadings -o vg_name 2>/dev/null | awk '{print $1}' | grep -qx "esdece"; then
        purge_vg "esdece"
    fi

    # If vgs usa exist, purge it
    echo "$(eval_gettext "Cleaning up LVM configurations... usa")"
    if danger sudo vgs --noheadings -o vg_name 2>/dev/null | awk '{print $1}' | grep -qx "usa"; then
        purge_vg "usa"
    fi

    # Cleanup loop devices and disk images if needed
    echo "$(eval_gettext "Cleaning up loop devices and disk images...")"

    # Detach loop devices
    # Get loop path from /dev/gsh_lvm_loop1 and /dev/gsh_lvm_loop2
    LOOP1=$(readlink -f /dev/gsh_lvm_loop1)
    LOOP2=$(readlink -f /dev/gsh_lvm_loop2)
    LOOP3=$(readlink -f /dev/gsh_lvm_loop3)

    if [ -e "$LOOP1" ]; then
        danger sudo losetup -d "$LOOP1"
    fi

    if [ -e "$LOOP2" ]; then
        danger sudo losetup -d "$LOOP2"
    fi

    if [ -e "$LOOP3" ]; then
        danger sudo losetup -d "$LOOP3"
    fi

    # Remove device links
    danger sudo rm -f /dev/gsh_lvm_loop1 /dev/gsh_lvm_loop2 /dev/gsh_lvm_loop3

    # Remove world/Esdea, world/Esdebe
    danger rm -rf "$GSH_HOME/Esdea/"
    danger rm -rf "$GSH_HOME/Esdebe/"

    # Remove disk images
    rm -f "$DATA_PATH/disk*.img"

    # Detach all unused loop devices (if any)
    danger sudo losetup -D

    return 0
}

mounting_villages() {

    local LVS=(
        "esdea/ouskelcoule"
        "esdea/douskelpar"
        "esdebe/grandflac"
    )

    local MOUNT_POINTS=(
        "$GSH_HOME/Esdea/Ouskelcoule"
        "$GSH_HOME/Esdea/Douskelpar"
        "$GSH_HOME/Esdebe/Grandflac"
    )

    local i=0
    for MOUNT_POINT in "${MOUNT_POINTS[@]}"; do
        # if LV does not exist , pass
        if [ ! -e "/dev/${LVS[$i]}" ]; then
            echo "$(eval_gettext "Logical volume /dev/\${LVS[\$i]} not found, skipping mount.")"
            i=$((i + 1))
            continue
        fi

        # if mount point does not exist pass
        if ! [ -d "$MOUNT_POINT" ]; then
            echo "$(eval_gettext "Creating mount point \$MOUNT_POINT")"
            mkdir -p "$MOUNT_POINT"
        fi

        # mount if not already mounted
        if ! mountpoint -q "$MOUNT_POINT"; then
            danger sudo mount "/dev/${LVS[$i]}" "$MOUNT_POINT"
            danger sudo chown -R "$USER:$USER" "$MOUNT_POINT"
        fi
        i=$((i + 1))
    done

    return 0
}

unmounting_villages() {
    local MOUNT_POINTS=(
        "$GSH_HOME/Esdea/Ouskelcoule"
        "$GSH_HOME/Esdea/Douskelpar"
        "$GSH_HOME/Esdebe/Grandflac"
        "$GSH_HOME/USA/Ouskelcoule"
        "$GSH_HOME/USA/Douskelpar"
        "$GSH_HOME/USA/Grandflac"
    )

    for MOUNT_POINT in "${MOUNT_POINTS[@]}"; do
        if mountpoint -q "$MOUNT_POINT"; then
            echo "$(eval_gettext "Unmounting \$MOUNT_POINT")"
            danger sudo umount "$MOUNT_POINT"
        fi
    done

    return 0
}


## LV TOOLS


# Helper: check filesystem type of a logical volume
check_lv_fs_type() {
    lv_path="$1"          # e.g. esdea/ouskelcoule
    expected="$2"         # e.g. ext4
    dev="/dev/$lv_path"

    # Read filesystem TYPE via blkid (empty if unformatted)
    fstype="$(danger sudo blkid -o value -s TYPE "$dev" 2>"/dev/null")"
    if [ -z "$fstype" ]; then
      return 3  # special code: no filesystem
    fi

    # Match expected type
    if [ "$fstype" = "$expected" ]; then
      return 0
    else
      return 1
    fi
}

check_lv_size() {
    VG_LV="$1"       # e.g. esdea/ouskelcoule
    TARGET="$2"      # requested size in Mo (e.g. 50)
    TOLERANCE="${3:-4}"  # default = 4 Mo

    # Extract actual size (in Mo, without "m")
    ACTUAL="$(danger sudo lvs "$VG_LV" --noheadings -o lv_size --units m \
              | awk '{gsub(/m/,""); gsub(/^ +| +$/,""); print $1}')"

    # Compute difference
    DIFF=$(awk -v act="$ACTUAL" -v tgt="$TARGET" 'BEGIN{ d=act-tgt; if(d<0)d=-d; print d }')

    # Check within tolerance
    RESULT=$(awk -v diff="$DIFF" -v tol="$TOLERANCE" 'BEGIN{ exit (diff <= tol ? 0 : 1) }')
    return $RESULT
}