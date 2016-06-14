#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:lynx2.8.8rel:.2

#OPT:openssl
#OPT:gnutls
#OPT:zip
#OPT:unzip
#OPT:sharutils


cd $SOURCE_DIR

URL=ftp://lynx.isc.org/lynx/tarballs/lynx2.8.8rel.2.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lynx/lynx2.8.8rel.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lynx/lynx2.8.8rel.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lynx/lynx2.8.8rel.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lynx/lynx2.8.8rel.2.tar.bz2 || wget -nc ftp://lynx.isc.org/lynx/tarballs/lynx2.8.8rel.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lynx/lynx2.8.8rel.2.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr          \
            --sysconfdir=/etc/lynx \
            --datadir=/usr/share/doc/lynx-2.8.8rel.2 \
            --with-zlib            \
            --with-bzlib           \
            --with-screen=ncursesw \
            --enable-locale-charset &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install-full &&
chgrp -v -R root /usr/share/doc/lynx-2.8.8rel.2/lynx_doc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -e '/#LOCALE/     a LOCALE_CHARSET:TRUE'     \
    -i /etc/lynx/lynx.cfg

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -e '/#DEFAULT_ED/ a DEFAULT_EDITOR:vi'       \
    -i /etc/lynx/lynx.cfg

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -e '/#PERSIST/    a PERSISTENT_COOKIES:TRUE' \
    -i /etc/lynx/lynx.cfg

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "lynx=>`date`" | sudo tee -a $INSTALLED_LIST

