#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:bluedevil:5.3.1

#REQ:kf5


cd $SOURCE_DIR

URL=http://download.kde.org/stable/plasma/5.3.1/bluedevil-5.3.1.tar.xz

wget -nc ftp://ftp.kde.org/pub/kde/stable/plasma/5.3.1/bluedevil-5.3.1.tar.xz || wget -nc http://download.kde.org/stable/plasma/5.3.1/bluedevil-5.3.1.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/bluedevil-5.3.1-bluezqt_api_changes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/bluedevil/bluedevil-5.3.1-bluezqt_api_changes-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../bluedevil-5.3.1-bluezqt_api_changes-1.patch &&
mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
      -DQML_INSTALL_DIR=lib/qt5/qml           \
      -DQT_PLUGIN_INSTALL_DIR=lib/qt5/plugins \
      .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "bluedevil=>`date`" | sudo tee -a $INSTALLED_LIST
