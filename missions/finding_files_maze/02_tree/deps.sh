if ! command -v tree > /dev/null; then
    echo "$(eval_gettext "The command 'tree' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'tree')")"
    false
fi
