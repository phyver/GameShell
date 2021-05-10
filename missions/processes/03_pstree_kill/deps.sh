if ! command -v ps > /dev/null; then
    echo "$(eval_gettext "The command 'ps' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'psproc')")"
    false
elif ! command -v pstree > /dev/null; then
    echo "$(eval_gettext "The command 'pstree' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'psmisc')")"
    false
fi
