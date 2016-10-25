#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:mate-panel:1.16.0

cd $SOURCE_DIR

URL="http://pub.mate-desktop.org/releases/1.16/mate-panel-1.16.0.tar.xz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static --with-gtk=3.0 &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "mate-panel=>`date`" | sudo tee -a $INSTALLED_LIST
