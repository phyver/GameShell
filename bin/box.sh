#!/bin/sh


working_dir=$(cd "$(dirname "$0")"; pwd -P)
PATH=$PATH:$working_dir

usage() {
  cat <<EOS
usage: $0 [options] [FILES]

with
  -E ENC     choose temporary encoding
             (default: nothing if awk supports UTF-8, ISO-8859-1 otherwise)
  -R WIDTH   reflow text at given width
             (default: 0, no reflow)
  -B BOX     choose box design (if empty, will only reflow the text)
             (default: ASCII)
  -W         choose width for the inside of the box
             (default: actual width of text)
  -H         choose height for the inside of the box
             (default: actual height of text)
  -h         this message
EOS
}

# choose gawk if it exists, as it knows how to deal with UTF-8
if command -v gawk >/dev/null
then
  AWK=gawk
else
  AWK=awk
fi

# default temporary encoding: use an 8bit encoding if awk doesn't supports
# UTF-8
if $AWK 'BEGIN {exit 3==length("héé") ? 0 : 1;}' || ! command -v iconv >/dev/null
then
  tmp_encoding=""
else
  tmp_encoding=ISO-8859-1
fi

# default box design
box=ASCII

# default reflow
reflow_width=0

while getopts "hW:H:R:E:B:" option
do
  case "$option" in
    W)
      width=$OPTARG
      ;;
    H)
      height=$OPTARG
      ;;
    R)
      reflow_width=$OPTARG
      ;;
    E)
      tmp_encoding=$OPTARG
      ;;
    B)
      box=$OPTARG
      ;;
    h)
      usage
      exit 0
      ;;
    *)
      echo "got option $option"
      usage
      exit 1
      ;;
  esac
done
shift $(($OPTIND - 1))

# get filename, or "-"
filename=${1:--}
if [ "$filename" != "-" ] && ! [ -f "$filename" ]
then
  echo "error: box.sh, '$filename' is not a file" &>2
  exit 1
fi

if [ -z "$tmp_encoding" ]
then
  ENCODE=cat
  DECODE=cat
else
  ENCODE="iconv -f UTF-8 -t \"$tmp_encoding\""
  DECODE="iconv -t UTF-8 -f \"$tmp_encoding\""
fi

if [ "$reflow_width" -eq 0 ]
then
  REFLOW=cat
else
  REFLOW="$AWK -f "$working_dir/reflow.awk" -v width=$reflow_width"
fi

if [ -z "$box" ]
then
  cat "$filename" | $ENCODE | $REFLOW | $DECODE
else
  # temporary file
  tmpfile=$(mktemp)

  cat "$filename" | $ENCODE | $REFLOW > "$tmpfile"

  # create awk boxes database if necessary
  [ -e "$working_dir/boxes-data.awk" ] || $AWK -f "$working_dir/../utils/create_boxes_data.awk" "$working_dir/../utils/boxes.db" > "$working_dir/boxes-data.awk"

  # get width / height of text
  if [ -z "$width" ] || [ -z "$height" ]
  then
    w_h=$($AWK '{w=w<length($0) ? length($0) : w;} END {print w, NR;}' "$tmpfile")
  fi

  if [ -z "$width" ]
  then
    width=$(echo "$w_h" | cut -d' ' -f1)
  fi

  if [ -z "$height" ]
  then
    height=$(echo "$w_h" | cut -d' ' -f2)
  fi

  $AWK -v box="$box" -v width=$width -v height=$height -f "$working_dir/boxes-data.awk" -f "$working_dir/box.awk" "$tmpfile" | $DECODE

  rm -f "$tmpfile"
fi
