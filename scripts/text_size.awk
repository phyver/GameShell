BEGIN {
  width = 0;
}

{
  w = wcscolumns($0);
  if (width < w) {
    width = w;
  }
}

END {
  print width, NR;
}

