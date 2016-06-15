#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libmusicbrainz:2.1.5

#OPT:python2


cd $SOURCE_DIR

URL=http://ftp.musicbrainz.org/pub/musicbrainz/historical/libmusicbrainz-2.1.5.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-2.1.5.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-2.1.5.tar.gz || wget -nc http://ftp.musicbrainz.org/pub/musicbrainz/historical/libmusicbrainz-2.1.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libmusicbrainz/libmusicbrainz-2.1.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-2.1.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-2.1.5.tar.gz || wget -nc ftp://ftp.musicbrainz.org/pub/musicbrainz/historical/libmusicbrainz-2.1.5.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/libmusicbrainz-2.1.5-missing-includes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/libmusicbrainz/libmusicbrainz-2.1.5-missing-includes-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../libmusicbrainz-2.1.5-missing-includes-1.patch &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`"


(cd python && python setup.py build)



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 -D docs/mb_howto.txt \
    /usr/share/doc/libmusicbrainz-2.1.5/mb_howto.txt

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
(cd python && python setup.py install)

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libmusicbrainz=>`date`" | sudo tee -a $INSTALLED_LIST

