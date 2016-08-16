#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:ldns:1.6.17

#REC:openssl
#OPT:cacerts
#OPT:libpcap
#OPT:python2
#OPT:swig
#OPT:doxygen


cd $SOURCE_DIR

URL=http://www.nlnetlabs.nl/downloads/ldns/ldns-1.6.17.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ldns/ldns-1.6.17.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ldns/ldns-1.6.17.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ldns/ldns-1.6.17.tar.gz || wget -nc http://www.nlnetlabs.nl/downloads/ldns/ldns-1.6.17.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ldns/ldns-1.6.17.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ldns/ldns-1.6.17.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's/defined(@$also)/@$also/' doc/doxyparse.pl &&
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --with-drill      &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "ldns=>`date`" | sudo tee -a $INSTALLED_LIST

