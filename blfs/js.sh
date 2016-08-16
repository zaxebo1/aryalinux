#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:mozjs:17.0.0

#REQ:libffi
#REQ:nspr
#REQ:python2
#REQ:zip
#OPT:doxygen


cd $SOURCE_DIR

URL=http://ftp.mozilla.org/pub/mozilla.org/js/mozjs17.0.0.tar.gz

wget -nc http://ftp.mozilla.org/pub/mozilla.org/js/mozjs17.0.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mozjs/mozjs17.0.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mozjs/mozjs17.0.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mozjs/mozjs17.0.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mozjs/mozjs17.0.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mozjs/mozjs17.0.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

cd js/src &&
sed -i 's/(defined\((@TEMPLATE_FILE)\))/\1/' config/milestone.pl &&
./configure --prefix=/usr       \
            --enable-readline   \
            --enable-threadsafe \
            --with-system-ffi   \
            --with-system-nspr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
find /usr/include/js-17.0/            \
     /usr/lib/libmozjs-17.0.a         \
     /usr/lib/pkgconfig/mozjs-17.0.pc \
     -type f -exec chmod -v 644 {} \;

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "js=>`date`" | sudo tee -a $INSTALLED_LIST

