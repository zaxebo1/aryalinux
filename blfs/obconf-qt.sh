#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:obconf-qt-0.9.0.8.gce85f:1

#REQ:cmake
#REQ:openbox
#REQ:qt5


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/other/obconf-qt-0.9.0.8.g1ce85f1.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/obconf-qt/obconf-qt-0.9.0.8.g1ce85f1.tar.xz || wget -nc http://anduin.linuxfromscratch.org/BLFS/other/obconf-qt-0.9.0.8.g1ce85f1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/obconf-qt/obconf-qt-0.9.0.8.g1ce85f1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/obconf-qt/obconf-qt-0.9.0.8.g1ce85f1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/obconf-qt/obconf-qt-0.9.0.8.g1ce85f1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/obconf-qt/obconf-qt-0.9.0.8.g1ce85f1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      ..       &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "obconf-qt=>`date`" | sudo tee -a $INSTALLED_LIST
