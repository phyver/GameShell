#!/bin/bash

S1=$(\ls $GASH_HOME/Chateau/Cave/.Terrier | checksum)
S2=$(cat $GASH_TMP/chats)


if [ "$S1" = "$S2" ]
then
    rm -f $GASH_TMP/chats
    unset S1 S2
    true
else
    rm -f $GASH_TMP/chats
    rm -f $GASH/Chateau/Cave/.Terrier/*
    unset S1 S2
    false
fi


