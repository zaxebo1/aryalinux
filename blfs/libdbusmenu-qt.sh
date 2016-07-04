#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libdbusmenu-qt:0.9.3+15.10.20150604

#REQ:cmake
#REQ:qt5
#OPT:doxygen


cd $SOURCE_DIR

URL=http://www.linuxfromscratch.org/~krejzi/libdbusmenu-qt-0.9.3+15.10.20150604.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt-0.9.3+15.10.20150604.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdbusmenu/libdbusmenu-qt-0.9.3+15.10.20150604.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt-0.9.3+15.10.20150604.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt-0.9.3+15.10.20150604.tar.xz || wget -nc http://www.linuxfromscratch.org/~krejzi/libdbusmenu-qt-0.9.3+15.10.20150604.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt-0.9.3+15.10.20150604.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_LIBDIR=lib  \
      -DWITH_DOC=OFF              \
      .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "libdbusmenu-qt=>`date`" | sudo tee -a $INSTALLED_LIST
