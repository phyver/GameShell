#!/bin/bash

_local_check() {
  local ENTRANCE="$(eval_gettext '$GASH_HOME/Castle/Entrance')"

  local N
  for N in $(seq 4)
  do
    local F="$(gettext "standard")_${N}"

    # Check that the standard file exists is in the chest
    if [ ! -f "$GASH_CHEST/${F}" ]
    then
      echo "$(eval_gettext "The standard \$N is not in the chest.")"
      return 1
    fi

    # Check that the standard is still in the entrance.
    if [ ! -f "${ENTRANCE}/${F}" ]
    then
      echo "$(eval_gettext "The standard \$N disapeared from the entrance.")"
      return 1
    fi

    # Check that the prefix of the first line is the name of the file.
    local P=$(cut -f 1 -d ' ' "$GASH_CHEST/${F}")
    if [ "$(echo "${P}" | cut -f1 -d '#')" != "${F}" ]
    then
      echo "$(eval_gettext "The standard \$N in the chest is not right.")"
      return 1
    fi

    # Same for the files in the entrance.
    P=$(cut -f 1 -d ' ' "${ENTRANCE}/${F}")
    if [ "$(echo "${P}" | cut -f1 -d '#')" != "${F}" ]
    then
      echo "$(eval_gettext "The standard \$N in the entrance is not right.")"
      return 1
    fi

    # Check that the suffix of the first line is the checksum.
    local S=$(cut -f 2 -d ' ' "$GASH_CHEST/${F}")
    if [ "${S}" != "$(checksum "${P}")" ]
    then
      echo "$(eval_gettext "The standard \$N in the chest is invalid.")"
      return 1
    fi

    # Same for the files in the entrance.
    S=$(cut -f 2 -d ' ' "${ENTRANCE}/${F}")
    if [ "${S}" != "$(checksum "${P}")" ]
    then
      echo "$(eval_gettext "The standard \$N in the entrance is invalid.")"
      return 1
    fi
  done

  return 0
}

if _local_check
then
  unset -f _local_check
  true
else
  find "$GASH_HOME" -name "$(gettext "standard")_?" -type f -print0 | xargs -0 rm -f
  unset -f _local_check
  false
fi
