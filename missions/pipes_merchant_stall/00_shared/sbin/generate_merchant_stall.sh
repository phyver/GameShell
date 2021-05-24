#!/bin/sh

firstname_file=firstnames.en
lastname_file=lastnames.en
object_file=objects.en

proba_paid=0.2
nb_transactions=10000
nb_boring_objects=5000
s_king='the King'
s_boring=boring_object
s_scroll=s_c_r_o_l_l
transaction_template='%s bought %s for %d coppers%s'
s_paid=PAID
nb_king=10

awk -v s_king="$s_king" \
    -v transaction_template="$transaction_template" \
    -v nb_transactions=$nb_transactions \
    -v nb_boring_objects=$nb_boring_objects \
    -v s_scroll=$s_scroll \
    -v s_boring=$s_boring \
    -v s_paid=$s_paid \
    -v nb_king=$nb_king \
    -v proba_paid=$proba_paid \
    -v seed=$(cat "$GSH_CONFIG/PRNG_seed") \
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

BEGIN {
    print transaction_template;
    srand(seed);
    nb_objects = 0;
    nb_firstnames = 0;
    nb_lastnames = 0;
    nb_king = 10;

    nb_transactions += int((0.1-rand()*0.2) * nb_transactions);
}

FILENAME ~ "firstname.*" {
    Firstname[nb_firstnames++] = $0;
}

FILENAME ~ "lastname.*" {
    Lastname[nb_lastnames++] = $0;
}

FILENAME ~ "object.*" {
    Object[nb_objects++] = $0;
}

END {
    printf("%d objects, %d firstnames, %d lastnames\n", nb_objects, nb_firstnames, nb_lastnames);

  print nb_boring_objects;
    for (i=0; i<nb_boring_objects; i++) {
        print > random_name(s_boring);
    }

    scroll = random_name(s_scroll);
    for (i=0; i<nb_transactions; i++) {
        o = Object[int(rand()*nb_objects)];
        if (i==0 || 1+int(rand()*nb_transactions) <= nb_king) {
            name = s_king;
        } else {
            name = sprintf("%s %s", Firstname[int(rand()*nb_firstnames)], Lastname[int(rand()*nb_lastnames)]);
        }
        price = 2 + int(rand()*5);
        p = rand() < proba_paid ? " -- " s_paid "." : ".";
        printf(transaction_template "\n", name, o, price, p) >> scroll;
    }

  printf("%s", int(2^32 * rand())) > seed_file;
}
END_OF_PROGRAM
