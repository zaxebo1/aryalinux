#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:libtool_.orig:2.4.2

cd $SOURCE_DIR

URL="http://archive.ubuntu.com/ubuntu/pool/main/libt/libtool/libtool_2.4.2.orig.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "libtool=>`date`" | sudo tee -a $INSTALLED_LIST

