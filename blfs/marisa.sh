#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

PACKAGE_NAME="marisa"

URL=http://archive.ubuntu.com/ubuntu/pool/universe/m/marisa/marisa_0.2.4.orig.tar.gz

cd $SOURCE_DIR
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make
sudo make install

cd $SOURCE_DIR
sudo rm -r $DIRECTORY

echo "$PACKAGE_NAME=>`date`" | sudo tee -a $INSTALLED_LIST
