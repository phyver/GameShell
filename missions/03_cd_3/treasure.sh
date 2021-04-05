cat "$(eval_gettext "\$MISSION_DIR/treasure/en.txt")"

export PS1="\n\w\n[mission \$(_get_current_mission)] $ "
