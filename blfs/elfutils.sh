#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:elfutils:0.165

#OPT:valgrind


cd $SOURCE_DIR

URL=https://fedorahosted.org/releases/e/l/elfutils/0.165/elfutils-0.165.tar.bz2

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/elfutils/elfutils-0.165.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/elfutils/elfutils-0.165.tar.bz2 || wget -nc https://fedorahosted.org/releases/e/l/elfutils/0.165/elfutils-0.165.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/elfutils/elfutils-0.165.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/elfutils/elfutils-0.165.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/elfutils/elfutils-0.165.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --program-prefix="eu-" &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "elfutils=>`date`" | sudo tee -a $INSTALLED_LIST

