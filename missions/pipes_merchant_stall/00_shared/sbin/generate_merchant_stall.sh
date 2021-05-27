#!/bin/sh

. gettext.sh

firstname_file=$MISSION_DIR/data/$(gettext 'firstnames.en')
lastname_file=$MISSION_DIR/data/$(gettext 'lastnames.en')
object_file=$MISSION_DIR/data/$(gettext 'objects.en')

s_king=$(gettext 'the King')
s_boring=$(gettext 'boring_object')
s_scroll=$(gettext 's_c_r_o_l_l')
transaction_template=$(gettext '%s bought %s for %d coppers%s')
s_paid=$(gettext 'PAID')

dir=$1
nb_king=10
proba_paid=0.995
nb_transactions=10000
nb_boring_objects=5000

awk -v dir="$dir" \
    -v s_king="$s_king" \
    -v transaction_template="$transaction_template" \
    -v nb_transactions=$nb_transactions \
    -v nb_boring_objects=$nb_boring_objects \
    -v s_scroll=$s_scroll \
    -v s_boring=$s_boring \
    -v s_paid=$s_paid \
    -v nb_king=$nb_king \
    -v proba_paid=$proba_paid \
    -v seed_file="$GSH_CONFIG/PRNG_seed" \
    -f- "$firstname_file" "$lastname_file" "$object_file" <<'END_OF_PROGRAM'
function r() {
  return int(65536*rand());
}
function random_name(s) {
  s1 = sprintf("%04x%04x%04x%04x", r(), r(), r(), r());
  s1 = substr(s1, 1, int(length(s1)/2 + rand()*(length(s1)/2)));
  s2 = sprintf("%04x%04x%04x%04x", r(), r(), r(), r());
  s1 = substr(s2, 1, int(length(s2)/2 + rand()*(length(s2)/2)));
  return sprintf("%s_%s_%s", s1, s, s2);
}
function pm(n, delta) {
  delta = int(n*delta);
  return n - delta + int((2*delta+1)*rand());
}

BEGIN {

  getline seed < seed_file;
  if (seed) srand(seed); else srand();

  # randomize numbers of things to generate
  nb_transactions = pm(nb_transactions, 0.1);
  nb_boring_objects = pm(nb_boring_objects, 0.1);
  nb_king = pm(nb_king, 0.2);
  nb_king_paid = pm(int(nb_king/2), 0.1);

  # counters
  nb_objects = 0;
  nb_firstnames = 0;
  nb_lastnames = 0;

  amountKing = 0;
  nbUnpaid = 0;
}

FILENAME ~ "firstname.*"  && $0 ~ "...*" {
  Firstname[nb_firstnames++] = $0;
}

FILENAME ~ "lastname.*"  && $0 ~ "...*" {
  Lastname[nb_lastnames++] = $0;
}

FILENAME ~ "object.*"  && $0 ~ "...*" {
  Object[nb_objects++] = $0;
}

END {
  # printf("%d objects, %d firstnames, %d lastnames\n", nb_objects, nb_firstnames, nb_lastnames);
  # printf("%d transaction, %d from the king, %d paid\n", nb_transactions, nb_king, nb_king_paid);

  # print nb_boring_objects;
  for (i=0; i<nb_boring_objects; i++) {
    filename = dir "/" random_name(s_boring);
    printf("") > filename;
  }

  scroll = random_name(s_scroll);
  for (i=0; i<nb_transactions; i++) {
    o = Object[int(rand()*nb_objects)];
    price = 2 + int(rand()*5);

    if (int(rand()*(nb_transactions-i)) < nb_king) {
      name = s_king;
      if (int(rand()*nb_king) < nb_king_paid) {
        p = " -- " s_paid ".";
        nb_king_paid--;
      } else {
        p = ".";
        amountKing += price;
        nbUnpaid++;
      }
      nb_king--;
    } else {
      name = sprintf("%s %s", Firstname[int(rand()*nb_firstnames)], Lastname[int(rand()*nb_lastnames)]);
      if (rand() < proba_paid) {
        p = " -- " s_paid ".";
      } else {
        p = ".";
        nbUnpaid++;
      }
    }
    filename = dir "/" scroll;
    printf(transaction_template "\n", name, o, price, p) >> filename;
  }
  filename = ENVIRON["GSH_VAR"]"/nbUnpaid";
  print nbUnpaid > filename;
  filename = ENVIRON["GSH_VAR"]"/amountKing";
  print amountKing > filename;

  if (seed) printf("%s", int(2^32 * rand())) > seed_file;
}
END_OF_PROGRAM
