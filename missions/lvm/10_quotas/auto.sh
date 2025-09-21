#!/usr/bin/env bash

# --- CONFIG (edit these paths to match your system) ---
DEV="/dev/esdea/ouskelcoule"  # device with the ext4 filesystem
MNT="$GSH_HOME/Esdea/Ouskelcoule"        # mountpoint of the ext4 filesystem
TARGET_DIR="$MNT/Grenier Banal"  # folder to limit
PROJID=4242                   # arbitrary project ID number
LIMIT_KO=1000                 # 1000 "Kroutons" (Ko)


# Add quota support to the filesystem
danger sudo umount "$MNT" 2>/dev/null
danger sudo tune2fs -O quota,project "$DEV"
danger sudo e2fsck -f "$DEV"


# Enable project quotas on the filesystem (temporary; add 'prjquota' to /etc/fstab to persist)
danger sudo mount -o prjquota "$DEV" "$MNT"

# Assign a project ID to the folder and make it inherit for subfiles/subdirs
danger sudo chattr -p "$PROJID" "$TARGET_DIR"
danger sudo chattr +P "$TARGET_DIR"

# Set the project quota (soft=hard=LIMIT_KO; in 1K blocks)
danger sudo setquota -P "$PROJID" "$LIMIT_KO" "$LIMIT_KO" 0 0 "$MNT"
