#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:opal:3.10.10

#REQ:ptlib
#OPT:ffmpeg
#OPT:libtheora
#OPT:openjdk
#OPT:ruby
#OPT:speex
#OPT:x264


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/opal/3.10/opal-3.10.10.tar.xz

wget -nc http://www.linuxfromscratch.org/patches/downloads/opal/opal-3.10.10-ffmpeg2-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/opal-3.10.10-ffmpeg2-1.patch
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/opal/opal-3.10.10.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/opal/3.10/opal-3.10.10.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/opal/opal-3.10.10.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/opal/opal-3.10.10.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/opal/3.10/opal-3.10.10.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/opal/opal-3.10.10.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/opal/opal-3.10.10.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../opal-3.10.10-ffmpeg2-1.patch &&
./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod -v 644 /usr/lib/libopal_s.a

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "opal=>`date`" | sudo tee -a $INSTALLED_LIST

