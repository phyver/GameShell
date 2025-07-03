#!/usr/bin/env sh

# This file is not required. When it exists, it is sourced on successfull
# completion of the mission and is added to the global configuration.
# It is typically used to "reward" the player with new features like aliases
# and the like.
# If you need this file, rename it to 'treasure.txt'
#
# Note that should the mission be completed in a subshell, aliases or
# environment variables will disappear.
# That typically happens a mission is checked using process redirection, as in
#   $ SOMETHING | gsh check
# To mitigate the problem, GameShell will display a message asking the player
# to run
#   $ gsh reset
# in that case.
