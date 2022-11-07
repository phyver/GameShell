#!/usr/bin/env sh

. gsh_gettext.sh

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
    -v s_scroll="$s_scroll" \
    -v s_boring="$s_boring" \
    -v s_paid="$s_paid" \
    -v nb_king="$nb_king" \
    -v proba_paid="$proba_paid" \
    -v seed_file="$GSH_CONFIG/PRNG_seed" \
    -f "$MISSION_DIR/sbin/generate_merchant_stall.awk" \
    "$firstname_file" "$lastname_file" "$object_file"
