if ! command -v pstree > /dev/null; then
    echo "$(eval_gettext "The command 'pstree' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'psmisc')")"
    false
fi
