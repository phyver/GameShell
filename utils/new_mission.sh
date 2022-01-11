#!/bin/sh

export GSH_ROOT="$(dirname "$0")/.."

display_help() {
cat <<EOH
$(basename "$0") NAME: create template for a new mission

options:
  -h          this message

  -N          no gettext
  -G          with gettext
  -M          output the Makefile on stdin
  -T          output the default template file on stdin
EOH
}


new_static_file() {
  MISSION_DIR="$1"
  cat <<'EOF' > "$MISSION_DIR"/static.sh
#!/bin/sh

# This file is not required: it is sourced once when initialising a GameShell
# game, and whenever the corresponding missions is (re)started.
# It typically creates the parts of the mission that will be available during
# the whole game, like the directory structure.
#
# Since it is sourced, it may define environment variables if you really need
# them, but it should "unset" any local variable it has created.
EOF
}

new_goal_txt_file() {
  MISSION_DIR="$1"
  cat <<'EOF' > "$MISSION_DIR"/goal.txt
This file or one of its more complex variants (refer to the documentation) is
required.

It is displayed in its entirety by the command
  $ gsh goal
It should describe the goal of the mission.

Note: if the __first_ line of this file is of the form
# variables: $VAR1 $VAR2
those variables are substituted in the file.
EOF
}

new_goal_gettext_file() {
  MISSION_DIR="$1"
  cat <<'EOF' > "$MISSION_DIR"/_goal.sh
#!/bin/sh

# This file is not required. It can be used to generate dynamic goal messages.
# If you need that, rename the file to 'goal.sh'.
#
# If the file exists, it is sourced by the command
#  $ gsh goal
# If neither this file nor "goal.txt" exists, the command
#  $ gsh goal
# is equivalent to having the following line in goal.sh
cat "$(eval_gettext '$MISSION_DIR/goal/en.txt')"
EOF

  mkdir "$MISSION_DIR/goal/"
  cat <<'EOF' > "$MISSION_DIR"/goal/en.txt
Mission goal
============

This file or one of its more complex variants (refer to the documentation) is
required.

It is displayed in its entirety by the command
  $ gsh goal
It should describe the goal of the mission.


Useful commands
===============

gsh check
  Checks that the missions has been completed.
EOF
}

new_init_file() {
  MISSION_DIR="$1"
  cat <<'EOF' > "$MISSION_DIR"/init.sh
#!/bin/sh

# This file is not required: it is sourced every time the mission is started.
# Since it is sourced every time the mission is restarted, it can generate
# random data to make each run slightly different.
#
# Since it is sourced, it may define environment variables if you really need
# them, but it should "unset" any local variable it has created.
#
# Note however that should the mission be initialized in a subshell, those
# environment variables will disappear! That typically happens a mission is
# checked using process redirection, as in
#   $ SOMETHING | gsh check
# To mitigate the problem, GameShell will display a message asking the player
# to run
#   $ gsh reset
# in that case.
#
# It typically looks like
_mission_init() {
  ...
}
_mission_init
EOF
}

new_check_file() {
  MISSION_DIR="$1"
  cat <<'EOF' > "$MISSION_DIR"/check.sh
#!/bin/sh

# This file is required. It is sourced when checking the goal of the mission
# has been achieved.
# It should end with a command returning 0 on success, and something else on
# failure.
# It should "unset" any local variable it has created, and any "global
# variable" that were only used for the mission. (The function _mission_check
# is automatically unset.)
#
# It typically looks like

_mission_check() {
  ...
}
_mission_check
EOF
}

new_auto_file() {
  MISSION_DIR="$1"
  cat <<'EOF' > "$MISSION_DIR"/_auto.sh
#!/bin/sh

# This file is not required. When it exists, it is used to automatically
# validate the mission. It should end with a succesful `gsh check` command.
# It is sometimes possible to "cheat" by using any hidden data in $GSH_TMP,
# but it is better to do it the "intended" way.
# If you write this file, rename it to auto.sh
EOF
}

new_clean_file() {
  MISSION_DIR="$1"
  cat <<'EOF' > "$MISSION_DIR"/_clean.sh
#!/bin/sh

# This file is not required. When it exists, it is used to clean the mission,
# for example on completion, or when restarting it.
# In some rare case, cleaning is different after a successful check. You can
# inspect the variable $GSH_LAST_ACTION, which can take the following values:
# assert, check_false, check_true, exit, goto, hard_reset, reset, skip
# If you need this file, rename it to clean.sh
EOF
}

new_treasure_file() {
  MISSION_DIR="$1"
  cat <<'EOF' > "$MISSION_DIR"/_treasure.sh
#!/bin/sh

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
EOF
}

new_treasure-msg_file() {
  MISSION_DIR="$1"
  cat <<'EOF' > "$MISSION_DIR"/_treasure-msg.txt
This file is not required. When it exists, it is displayed when sourcing the
"treasure.sh" file. (If no "treasure.sh" file exists, this file will be
ignored.)
EOF
}

new_gettext_treasure-msg_file() {
  MISSION_DIR="$1"
  cat <<'EOF' > "$MISSION_DIR"/_treasure-msg.sh
#!/bin/sh

# This file is not required. It can be used to generate dynamic treasure
# messages.
# If you need this file, rename it to 'treasure-msg.sh'
#
# If the file exists, it is sourced when the mission is succesfully checked,
# when the treasure is sourced.
# If neither this file nor "treasure-msg.txt" exists, a "treasure-msg.sh" file
# with a single line is assumed:
cat "$(eval_gettext '$MISSION_DIR/treasure-msg/en.txt')"
EOF

  mkdir "$MISSION_DIR/treasure-msg/"
  cat <<'EOF' > "$MISSION_DIR"/treasure-msg/en.txt
This file is not required. When it exists, it is displayed when sourcing the
"treasure.sh" file. (If no "treasure.sh" file exists, this file will be
ignored.)
EOF
}

new_test_file() {
  MISSION_DIR="$1"
  cat <<'EOF' > "$MISSION_DIR"/_test.sh
#!/bin/sh

# This file is not required: it is sourced by the command "gsh test" for
# testing during development.
# If you write this file, rename it to 'test.sh'
#
# You can use some special commands
# gsh assert check true
# gsh assert check false
# gsh assert CONDITION
# to check that specific conditions are satisfied.
#
# Since it is sourced, it may define environment variables if you really need
# them, but it should "unset" any local variable it has created.
EOF
}

new_template_file() {
  cat <<'EOF'
msgid ""
msgstr ""
"Content-Type: text/plain; charset=UTF-8\n"
"Content-Transfer-Encoding: 8bit\n"

# path for the text file containing the goal
msgid "$MISSION_DIR/goal/en.txt"
msgstr ""

# path for the text file containing the treasure message
msgid "$MISSION_DIR/treasure-msg/en.txt"
msgstr ""

# path for the text file containing the skip message
msgid "$MISSION_DIR/skip/en.txt"
msgstr ""
EOF
}

new_makefile() {
  cat <<'EOF'
SH_FILES=$(wildcard *.sh)
EXCEPTIONS=
OTHER_FILES=

LANGUAGES=$(wildcard i18n/*.po)
LANGUAGES:=$(filter-out i18n/en.po, $(LANGUAGES))
SH_FILES:=$(filter-out $(EXCEPTIONS), $(SH_FILES))
SORT=--sort-output
OPTIONS=--indent --no-wrap --no-location

all: i18n/en.po $(LANGUAGES)

add-locations: SORT=--add-location --sort-by-file
add-locations: all

i18n/en.po: i18n/template.pot FORCE
	@echo "msgen $@"
	@msgen $(OPTIONS) $(SORT) i18n/template.pot --output=$@
	@echo "# AUTOMATICALLY GENERATED -- DO NOT EDIT" | cat - $@ > $@~
	@mv $@~ $@

$(LANGUAGES):%.po: i18n/template.pot FORCE
	@echo "msgmerge $@"
	@msgmerge --update $(OPTIONS) $(SORT) $@ i18n/template.pot

i18n/template.pot: $(SH_FILES) $(OTHER_FILES) FORCE
	@mkdir -p i18n/
	@echo "generating i18n/template.pot"
	@xgettext --from-code=UTF-8 --omit-header $(OPTIONS) $(SORT) --join-existing --output i18n/template.pot $(SH_FILES) $(OTHER_FILES)
	@echo "done"

new: i18n/template.pot
	@read -p "language code: " lang; \
		[ -e "./i18n/$$lang.po" ] && echo "file i18n/$$lang.po already exists" && exit; \
		echo "file i18n/$$lang.po created"; \
		msgcat $(OPTIONS) --output i18n/$$lang.po i18n/template.pot

clean:
	rm -f i18n/*~

.PHONY: all clean new FORCE
EOF
}

new_mission_without_gettext() {
  NAME=$1
  MISSION_DIR="$GSH_ROOT/missions/contrib/${NAME}"

  if [ -e "$MISSION_DIR" ]
  then
    echo "Path \$GSH_ROOT/${MISSION_DIR#$GSH_ROOT/} already exists!" >&2
    echo "aborting" >&2
    exit 1
  fi

  echo "Creating mission \$GSH_ROOT/missions/contrib/$NAME"
  mkdir -p "$MISSION_DIR"

  new_static_file "$MISSION_DIR"
  new_goal_txt_file "$MISSION_DIR"
  new_init_file "$MISSION_DIR"
  new_check_file "$MISSION_DIR"
  new_auto_file "$MISSION_DIR"
  new_clean_file "$MISSION_DIR"
  new_treasure_file "$MISSION_DIR"
  new_treasure-msg_file "$MISSION_DIR"
  new_test_file "$MISSION_DIR"
}


new_mission_with_gettext() {
  NAME=$1
  MISSION_DIR="$GSH_ROOT/missions/contrib/${NAME}"

  if [ -e "$MISSION_DIR" ]
  then
    echo "Path \$GSH_ROOT/${MISSION_DIR#$GSH_ROOT/} already exists!" >&2
    echo "aborting" >&2
    exit 1
  fi

  echo "Creating mission \$GSH_ROOT/missions/contrib/$NAME"
  mkdir -p "$MISSION_DIR"

  new_static_file "$MISSION_DIR"
  new_goal_gettext_file "$MISSION_DIR"
  new_init_file "$MISSION_DIR"
  new_check_file "$MISSION_DIR"
  new_auto_file "$MISSION_DIR"
  new_clean_file "$MISSION_DIR"
  new_treasure_file "$MISSION_DIR"
  new_gettext_treasure-msg_file "$MISSION_DIR"
  mkdir -p "$MISSION_DIR"/i18n/
  new_template_file > "$MISSION_DIR"/i18n/template.pot
  new_makefile > "$MISSION_DIR"/Makefile
  new_test_file "$MISSION_DIR"
}


GETTEXT=""
while getopts ":hNGMT" opt
do
  case $opt in
    h)
      display_help
      exit 0;
      ;;
    N)
      GETTEXT=0
      ;;
    G)
      GETTEXT=1
      ;;
    M)
      new_makefile
      exit 0
      ;;
    T)
      new_template_file
      exit 0
      ;;
    *)
      echo "invalid option: '-$OPTARG'" >&2
      exit 1
  esac
done
shift $((OPTIND - 1))

NAME=$1

if [ -z "$GETTEXT" ]
then
  echo "You must choose either '-N' (no gettext support) or '-G' (gettext support)." >&2
  exit 1
elif [ "$GETTEXT" = 0 ]
then
  new_mission_without_gettext "$NAME"
elif [ "$GETTEXT" = 1 ]
then
  new_mission_with_gettext "$NAME"
else
  echo "Oops... Unknown GETTEXT value." >&2
  exit 1
fi
