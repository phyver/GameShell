#!/bin/bash

GASH_BASE=$(readlink -f $(dirname $0)/..)

source $GASH_BASE/lib/utils.sh


NAME="GameShell"
TMP_DIR=$(mktemp -d)
mkdir $TMP_DIR/$NAME


cp --archive $GASH_BASE/start.sh $GASH_BASE/bin $GASH_BASE/lib $TMP_DIR/$NAME

mkdir $TMP_DIR/$NAME/missions
cp --archive $GASH_BASE/missions/* $TMP_DIR/$NAME/missions
# remove auto.sh files
find $TMP_DIR/$NAME/missions -name auto.sh | xargs rm -f

# admin password
ADMIN_PASSWD="bbq"
ADMIN_HASH=$(checksum $ADMIN_PASSWD)
sed -i "s/^export ADMIN_HASH='[0-9a-f]*'$/export ADMIN_HASH='$ADMIN_HASH'/" $TMP_DIR/$NAME/lib/utils.sh

cd $TMP_DIR
tar --create --file $NAME.tar $NAME
mv $NAME.tar $GASH_BASE/../
rm -rf $TMP_DIR


# TODO
# generate archive with given missions
# generate archive with given admin passwd
# generate archive with / without "auto.sh" scripts
