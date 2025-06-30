#!/usr/bin/env sh

# This file is not required. When it exists, it is used to clean the mission,
# for example on completion, or when restarting it.
# In some rare case, cleaning is different after a successful check. You can
# inspect the variable $GSH_LAST_ACTION, which can take the following values:
# assert, check_false, check_true, exit, goto, hard_reset, reset, skip
# If you need this file, rename it to clean.sh
<<<<<<< HEAD:missions/contrib/git_branching/01_clone/_clean.sh
=======

rm -rf $GSH_HOME/Castle/Portals/al_jeit
>>>>>>> a71f653 (refactoring missions with new lore):missions/contrib/git_branching/05a_questions/clean.sh
