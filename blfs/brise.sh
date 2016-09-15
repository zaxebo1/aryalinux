#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

PACKAGE_NAME="brise"

URL=http://archive.ubuntu.com/ubuntu/pool/universe/b/brise/brise_0.35.orig.tar.gz

cd $SOURCE_DIR
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

make
sudo make install

cd $SOURCE_DIR
sudo rm -r $DIRECTORY

echo "$PACKAGE_NAME=>`date`" | sudo tee -a $INSTALLED_LIST