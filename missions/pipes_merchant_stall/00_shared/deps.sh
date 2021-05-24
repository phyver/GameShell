if ! command -v python3 &> /dev/null
then
  echo "$(eval_gettext "The command 'python3' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'python3')")"
  false
elif ! command -v generate_merchant_stall.py &> /dev/null
then
  # FIXME: change message
  echo "$(eval_gettext "The script 'generate_merchant_stall.py' is necessary for mission \$MISSION_NAME.
Make sure the corresponding mission is included.")"
  false
fi
