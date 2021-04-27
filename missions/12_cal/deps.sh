if ! command -v cal > /dev/null; then
    echo "$(eval_gettext "The command 'cal' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'bsdmainutils')")"
    false
fi
