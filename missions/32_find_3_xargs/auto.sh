mkdir -p "$GASH_COFFRE"
cd "$(find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -name "$(gettext "maze")" -type d)"
find . -type f -print0 | xargs -0 grep -Zl "$(gettext "diamond")" |  xargs -0 mv -t "$GASH_COFFRE"
gash check
