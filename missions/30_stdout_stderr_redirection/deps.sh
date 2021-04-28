if ! command -v gcc > /dev/null && ! command -v clang && ! command -v cc && ! command -v python3 > /dev/null ; then
    echo "$(eval_gettext "The python3 interpreter, or a C compiler is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install one of the packages 'python3', 'gcc' or 'clang')")"
    false
fi
