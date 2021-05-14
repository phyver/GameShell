if ! command -v ps &> /dev/null; then
    echo "$(eval_gettext "The command 'ps' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'psproc')")"
    false
fi
