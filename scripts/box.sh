#!/bin/sh


cd -P "$(dirname "$0")"

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
  # tmp_encoding=ISO-8859-1
  tmp_encoding=LATIN1
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
shift $((OPTIND - 1))

# get filename, or "-"
filename=${1:--}
if [ "$filename" != "-" ] && ! [ -f "$filename" ]
then
  echo "error: box.sh, '$filename' is not a file" >&2
  exit 1
fi

encode() {
  input=${1:--}
  if [ -z "$tmp_encoding" ]
  then
    cat "$input"
  else
    # NOTE: macOS' iconv doesn't accept "-" as a filename for stdin
    cat "$input" | iconv -f UTF-8 -t "$tmp_encoding"
  fi
}
decode() {
  input=${1:--}
  if [ -z "$tmp_encoding" ]
  then
    cat "$input"
  else
    # NOTE: macOS' iconv doesn't accept "-" as a filename for stdin
    cat "$input" | iconv -t UTF-8 -f "$tmp_encoding"
  fi
}
reflow() {
  input=${1:--}
  if [ "$reflow_width" -eq 0 ]
  then
    cat "$input"
  else
    $AWK -f ./reflow.awk -v width="$reflow_width" "$input"
  fi
}

if [ -z "$box" ]
then
  encode "$filename" | reflow | decode
else
  # temporary file
  tmpfile=$(mktemp)

  encode "$filename" | reflow > "$tmpfile"

  # create awk boxes database if necessary
  [ -e ./boxes-data.awk ] || $AWK -f ./create_boxes_data.awk ../lib/boxes.db > ./boxes-data.awk

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

  $AWK -v box="$box" -v width="$width" -v height="$height" -f ./boxes-data.awk -f ./box.awk "$tmpfile" | decode

  rm -f "$tmpfile"
fi
