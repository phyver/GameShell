#!/bin/awk -f
BEGIN {
  t["T"] = 1;
  t["M"] = 2;
  t["B"] = 3;
}

/^%%% / {
  sub("^%%% *", "", $0);
  design = $0;
  DESIGNS[++nb_designs] = design;
  BOX[design, "height", 1] = 0;
  BOX[design, "height", 2] = 0;
  BOX[design, "height", 3] = 0;
}

/^[TMB]:/ {
  n = split(substr($0, 3), T, "%");
  if (n != 3) {
    print "PB", $0;
    next;
  }
  i = t[substr($0, 1, 1)];
  BOX[design, "height", i]++;
  h = BOX[design, "height", i];
  BOX[design, i, 1, h] = T[1];
  BOX[design, i, 2, h] = T[2];
  BOX[design, i, 3, h] = T[3];
}

/^margin:/ {
  n = split(substr($0, 8), TMP);
  if (n != 4) {
    print "PROBLEM, got", substr($0, 7) > "/dev/stderr";
    exit 1;
  }
  for (k in TMP) {
    BOX[design, "margin", k] = TMP[k];
  }
}
/^neg_margin:/ {
  n = split(substr($0, 12), TMP);
  if (n != 4) {
    print "PROBLEM, got", substr($0, 7) > "/dev/stderr";
    exit 1;
  }
  for (k in TMP) {
    BOX[design, "neg_margin", k] = TMP[k];
  }
}


function def_block(bl, h, design, x, y) {
  for (i=1; i<=h; i++) {
    gsub(/\\/, "&&", BOX[design, x, y, i]);
    gsub(/"/, "\\&", BOX[design, x, y, i]);
    printf("    %s[%d] = \"%s\";\n", bl, i, BOX[design, x, y, i]);
  }
}
END {
  print "# DO NOT MODIFY, AUTOMATICALLY GENERATED";
  print "BEGIN {";

  ELSE = "";
  for (k in DESIGNS) {
    design = DESIGNS[k];
    printf("  %sif (box == \"%s\") {\n", ELSE, design);
    printf("    Th = %d;\n", BOX[design, "height", 1]);
    printf("    Mh = %d;\n", BOX[design, "height", 2]);
    printf("    Bh = %d;\n", BOX[design, "height", 3]);
    def_block("TL", BOX[design, "height", 1], design, 1, 1);
    def_block("ML", BOX[design, "height", 2], design, 2, 1);
    def_block("BL", BOX[design, "height", 3], design, 3, 1);

    def_block("TC", BOX[design, "height", 1], design, 1, 2);
    def_block("BC", BOX[design, "height", 3], design, 3, 2);

    def_block("TR", BOX[design, "height", 1], design, 1, 3);
    def_block("MR", BOX[design, "height", 2], design, 2, 3);
    def_block("BR", BOX[design, "height", 3], design, 3, 3);
    printf("    margin[\"T\"] = %d;\n", BOX[design, "margin", 1])
    printf("    margin[\"R\"] = %d;\n", BOX[design, "margin", 2])
    printf("    margin[\"B\"] = %d;\n", BOX[design, "margin", 3])
    printf("    margin[\"L\"] = %d;\n", BOX[design, "margin", 4])
    printf("    neg_margin[\"T\"] = %d;\n", BOX[design, "neg_margin", 1])
    printf("    neg_margin[\"R\"] = %d;\n", BOX[design, "neg_margin", 2])
    printf("    neg_margin[\"B\"] = %d;\n", BOX[design, "neg_margin", 3])
    printf("    neg_margin[\"L\"] = %d;\n", BOX[design, "neg_margin", 4])
    printf("  }");
    ELSE = " else "
  }
  print " else {";
  printf("    printf(\"availabe boxes:\\n\") > \"/dev/stderr\"; \n");
  for (k in DESIGNS) {
    printf("    printf(\"%s \") > \"/dev/stderr\";\n", DESIGNS[k]);
  }
  printf("  }\n}\n");
}
