#!/bin/bash

book=$GSH_VAR/additions.txt
rm -f "$book"
questions=$GSH_VAR/arith.txt
rm -f "$questions"

for _ in $(seq 5)
do
    a=$((1+RANDOM%100))
    b=$((1+RANDOM%100))
    c=$((a + b))
    echo $c >> "$book"
    echo "$a + $b = ?? |$c" >> "$questions"
done
unset a b c book questions
