#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:lxde-icon-theme:0.5.1

#OPT:gtk2
#OPT:gtk3


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/lxde/lxde-icon-theme-0.5.1.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxde-icon-theme/lxde-icon-theme-0.5.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxde-icon-theme/lxde-icon-theme-0.5.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxde-icon-theme/lxde-icon-theme-0.5.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxde-icon-theme/lxde-icon-theme-0.5.1.tar.xz || wget -nc http://downloads.sourceforge.net/lxde/lxde-icon-theme-0.5.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxde-icon-theme/lxde-icon-theme-0.5.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache -qf /usr/share/icons/nuoveXT2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "lxde-icon-theme=>`date`" | sudo tee -a $INSTALLED_LIST

