#!/bin/bash

GASH_BASE=$(readlink -f $(dirname $0)/..)

source $GASH_BASE/lib/utils.sh


NAME="GameShell"
TMP_DIR=$(mktemp -d)
mkdir $TMP_DIR/$NAME

MISSIONS="??_*"

# copy source files
cp --archive $GASH_BASE/start.sh $GASH_BASE/bin $GASH_BASE/lib $TMP_DIR/$NAME

# copy missions
mkdir $TMP_DIR/$NAME/missions
cd $GASH_BASE/missions
N=1
for m in $MISSIONS
do
    N=$(echo -n "0000$N" | tail -c 2)
    MISSION_DIR=$TMP_DIR/$NAME/missions/${N}_${m#*_}
    mkdir $MISSION_DIR
    cp --archive $m/* $MISSION_DIR
    N=$((10#$N + 1))
done

# remove auto.sh files
find $TMP_DIR/$NAME/missions -name auto.sh | xargs rm -f

# change admin password
ADMIN_PASSWD="bbq"
ADMIN_HASH=$(checksum $ADMIN_PASSWD)
sed -i "s/^export ADMIN_HASH='[0-9a-f]*'$/export ADMIN_HASH='$ADMIN_HASH'/" $TMP_DIR/$NAME/lib/utils.sh

# create archive
cd $TMP_DIR
tar --create --file $NAME.tar $NAME
mv $NAME.tar $GASH_BASE/../
rm -rf $TMP_DIR


# TODO
# generate archive with given missions
# generate archive with given admin passwd
# generate archive with / without "auto.sh" scripts
