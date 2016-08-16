#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:librep_:0.92.6

#OPT:libffi


cd $SOURCE_DIR

URL=http://download.tuxfamily.org/librep/librep_0.92.6.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/librep/librep_0.92.6.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/librep/librep_0.92.6.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/librep/librep_0.92.6.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/librep/librep_0.92.6.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/librep/librep_0.92.6.tar.xz || wget -nc http://download.tuxfamily.org/librep/librep_0.92.6.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./autogen.sh --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "librep=>`date`" | sudo tee -a $INSTALLED_LIST

