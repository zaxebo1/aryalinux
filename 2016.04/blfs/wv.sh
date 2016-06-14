#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:wv:1.2.9

#REQ:libgsf
#REQ:libpng


cd $SOURCE_DIR

URL=http://www.abisource.com/downloads/wv/1.2.9/wv-1.2.9.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wv/wv-1.2.9.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wv/wv-1.2.9.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wv/wv-1.2.9.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wv/wv-1.2.9.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wv/wv-1.2.9.tar.gz || wget -nc http://www.abisource.com/downloads/wv/1.2.9/wv-1.2.9.tar.gz

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
echo "wv=>`date`" | sudo tee -a $INSTALLED_LIST

