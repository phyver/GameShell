if [ -z "$DISPLAY" ]; then
    echo "$(eval_gettext "The variable DISPLAY is not defined.
A running X server is required for mission \$MISSION_NAME.")"
    false
fi

if ! command -v xeyes > /dev/null; then
    echo "$(eval_gettext "The command 'xeyes' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'x11-apps')")"
    false
fi
