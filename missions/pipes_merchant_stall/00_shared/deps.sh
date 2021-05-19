if ! command -v python3 &> /dev/null
then
    echo "$(eval_gettext "The command 'python3' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'python3')")"
    false
elif ! command -v genStall.py &> /dev/null
then
    echo "$(eval_gettext "The script 'genStall.py' is necessary for mission \$MISSION_NAME.
Make sure the corresponding mission is included.")"
    false
fi
