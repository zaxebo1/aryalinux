#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Pixman package contains abr3ak library that provides low-level pixel manipulation features such asbr3ak image compositing and trapezoid rasterization.br3ak"
SECTION="general"
VERSION=0.34.0
NAME="pixman"

#OPT:gtk2
#OPT:libpng


cd $SOURCE_DIR

URL=http://cairographics.org/releases/pixman-0.34.0.tar.gz

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pixman/pixman-0.34.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pixman/pixman-0.34.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pixman/pixman-0.34.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pixman/pixman-0.34.0.tar.gz || wget -nc http://cairographics.org/releases/pixman-0.34.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pixman/pixman-0.34.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
