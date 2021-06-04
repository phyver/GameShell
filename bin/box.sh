#!/bin/sh

dir=$(dirname "$0")

# choose gawk if it exists, as it knows how to deal with UTF-8
if command -v gawk >/dev/null
then
  AWK=gawk
else
  AWK=awk
fi

# define an 8bit encoding if awk doesn't supports UTF-8
if $AWK 'BEGIN {exit 3==length("héé") ? 0 : 1;}' || ! command -v iconv >/dev/null
then
  TMP_ENC=""
else
  TMP_ENC=ISO-8859-1
fi

# get the box design
box=ASCII
if [ "$1" = "-b" ]
then
  box=$2
  shift 2
fi

# get the width
if [ "$COLUMNS" -ge 80 ]
then
  WIDTH=$((COLUMNS - 30))
  PARCHMENT=true
else
  WIDTH=$COLUMNS
  PARCHMENT=false
fi

# get filename, or "-"
filename=$1
[ -n "$filename" ] || filename=-

# temporary file
tmpfile=$(mktemp)

if [ -z "$TMP_ENC" ]
then
  reflow.awk -v width=$WIDTH "$filename" > "$tmpfile"
else
  iconv -f UTF-8 -t "$TMP_ENC" "$filename" | reflow.awk -v width=$WIDTH > "$tmpfile"
fi

if [ "$PARCHMENT" = false ]
then
  cat $tmpfile
else
  # create awk boxes database if necessary
  [ -e "$dir/boxes-data.awk" ] || $AWK -f "$dir/../utils/create_boxes_data.awk" "$dir/../utils/boxes.db" > "$dir/boxes-data.awk"

  # get width / height of text
  size=$($AWK '{w=w<length($0) ? length($0) : w;} END {printf("-v width=%d -v height=%d", w, NR);}' < "$tmpfile")

  # add box
  if [ -z "$TMP_ENC" ]
  then
    $AWK -v box="$box" $size -f "$dir/boxes-data.awk" -f "$dir/box.awk" "$tmpfile"
  else
    $AWK -v box="$box" $size -f "$dir/boxes-data.awk" -f "$dir/box.awk" "$tmpfile" | iconv -f $TMP_ENC -t UTF-8
  fi
fi

rm -f "$tmpfile"
