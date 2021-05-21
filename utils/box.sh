#!/bin/sh

box() {
  case $# in
    1)
      box=$1
      filename=$(mktemp)
      cat > "$filename"
      ;;
    2)
      box=$1
      filename=$2
      ;;
    *)
      echo "Usage: $0 BOX [FILENAME]" &>2
      return 1
  esac


  size=$(awk '{w=w<length($0) ? length($0) : w;} END {printf("-v width=%d -v height=%d", w, NR);}' < "$filename")
  awk -v box=$box $size -f "$(dirname "$0")/box-data.awk" -f "$(dirname "$0")/box.awk" < "$filename"

  if [  "$#" -eq 1 ]
  then
    rm -f "$filename"
  fi
}

box "$@"
