#!/bin/sh

dir=$(dirname "$0")

# choose gawk if it exists, as it knows how to deal with UTF-8
if command -v gawk >/dev/null
then
  AWK=gawk
else
  AWK=awk
fi

# create awk boxes database if necessary
[ -e "$dir/boxes-data.awk" ] || $AWK -f "$dir/../utils/create_boxes_data.awk" "$dir/../utils/boxes.db" > "$dir/boxes-data.awk"

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

if [ -n "$1" ] && [ -z "$TMP_ENC" ]
then
  filename=$1
elif [ -n "$1" ] && [ -n "$TMP_ENC" ]
then
  tmpfile=$(mktemp)
  iconv -f UTF-8 -t "$TMP_ENC" < "$1" > "$tmpfile"
  filename=$tmpfile
elif [ -z "$1" ] && [ -z "$TMP_ENC" ]
then
  tmpfile=$(mktemp)
  cat > "$tmpfile"
  filename=$tmpfile
elif [ -z "$1" ] && [ -n "$TMP_ENC" ]
then
  tmpfile=$(mktemp)
  iconv -f UTF-8 -t "$TMP_ENC" > "$tmpfile"
  filename=$tmpfile
else
  echo "error: box.sh" >&2
  exit 1
fi

# get width / height of text
size=$($AWK '{w=w<length($0) ? length($0) : w;} END {printf("-v width=%d -v height=%d", w, NR);}' < "$filename")

# add box
if [ -z "$TMP_ENC" ]
then
  $AWK -v box="$box" $size -f "$dir/boxes-data.awk" -f "$dir/box.awk" "$filename"
else
  $AWK -v box="$box" $size -f "$dir/boxes-data.awk" -f "$dir/box.awk" "$filename" | iconv -f $TMP_ENC -t UTF-8
fi

rm -f "$tmpfile"
