#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:obexfs:0.12

#REQ:openobex
#REQ:obexftp

cd $SOURCE_DIR

URL="http://triq.net/obexftp/obexfs-0.12.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "obexfs=>`date`" | sudo tee -a $INSTALLED_LIST
