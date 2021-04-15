#!/bin/bash

book="$GASH_TMP/additions.txt"
rm -f "$book"
questions=$GASH_TMP/arith.txt
rm -f "$questions"

for _ in $(seq 5)
do
    a=$((1+RANDOM%100))
    b=$((1+RANDOM%100))
    c=$((a + b))
    echo $c >> "$book"
    echo "$a + $b = ?? |$c" >> "$questions"
done
