function r() {
  return int(65536*rand());
}
function random_name() {
  s = sprintf("%04x%04x%04x%04x%04x%04x%04x%04x", r(), r(), r(), r(), r(), r(), r(), r());
  s = substr(s, 1, 8 + int(rand()*24));
  return s;
}

BEGIN {
  getline seed < seed_file;
  if (seed) srand(seed); else srand();

  nb_remaining_path = WIDTH^DEPTH;

  # print "DEPTH = ", DEPTH;
  # print "WIDTH = ", WIDTH;
  # print "nb_random_path =", nb_random_path;

  current_level = 0;
  while (1) {
    # printf("POS = ");
    # for (i=0;i<current_level;i++) printf("%d, ", POS[i]);
    # printf("\n");
    # printf("PATH = ");
    # for (i=0;i<current_level;i++) printf("%s, ", PATH[i]);
    # printf("\n");

    if (current_level < DEPTH) {
      POS[current_level] = 0;
      PATH[current_level] = random_name();
      current_level++;
    } else {
      while (current_level >= 0) {
        if (POS[current_level-1] == WIDTH-1) {
          current_level--;
        } else {
          break;
        }
      }
      if (current_level > 0) {
        POS[current_level-1]++;
        PATH[current_level-1] = random_name();
      } else {
        break;
      }
    }

    if (current_level == DEPTH) {
      path = DIR;
      for (i=0; i<current_level; i++) {
        path = path "/" PATH[i];
      }
      if (leaf_content) {
        printf(leaf_content) > path;
        close(path);
        # much faster than system("touch " path);
      } else {
        system("mkdir -p " path);
        # FIXME: that's quite slow!
      }
      if (int(rand()*nb_remaining_path) < nb_random_path) {
        print path;
        nb_random_path--;
      }
      nb_remaining_path--;
    } else if (leaf_content && current_level == DEPTH-1) {
      path = DIR;
      for (i=0; i<current_level; i++) {
        path = path "/" PATH[i];
      }
      system("mkdir -p " path);
      # FIXME: that's quite slow!
    }
  }

  if (seed) printf("%s", int(2^32 * rand())) > seed_file;
}
