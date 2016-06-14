#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:thunar-volman:0.8.1

#REQ:exo
#REQ:libgudev
#REQ:libxfce4ui
#REC:libnotify
#REC:startup-notification
#OPT:gvfs
#OPT:polkit-gnome


cd $SOURCE_DIR

URL=http://archive.xfce.org/src/xfce/thunar-volman/0.8/thunar-volman-0.8.1.tar.bz2

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/thunar-volman/thunar-volman-0.8.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/thunar-volman/thunar-volman-0.8.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/thunar-volman/thunar-volman-0.8.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/thunar-volman/thunar-volman-0.8.1.tar.bz2 || wget -nc http://archive.xfce.org/src/xfce/thunar-volman/0.8/thunar-volman-0.8.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/thunar-volman/thunar-volman-0.8.1.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "thunar-volman=>`date`" | sudo tee -a $INSTALLED_LIST

