#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:lame:3.99.5

#OPT:libsndfile
#OPT:nasm


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/lame/lame-3.99.5.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lame/lame-3.99.5.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lame/lame-3.99.5.tar.gz || wget -nc http://downloads.sourceforge.net/lame/lame-3.99.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lame/lame-3.99.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lame/lame-3.99.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lame/lame-3.99.5.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

case $(uname -m) in
   i?86) sed -i -e '/xmmintrin\.h/d' configure ;;
esac


./configure --prefix=/usr --enable-mp3rtp --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make pkghtmldir=/usr/share/doc/lame-3.99.5 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "lame=>`date`" | sudo tee -a $INSTALLED_LIST

