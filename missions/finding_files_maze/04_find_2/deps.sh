if ! command -v man > /dev/null; then
    echo "$(eval_gettext "The command 'man' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'man-db')")"
    false
fi
