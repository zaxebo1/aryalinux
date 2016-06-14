#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:file-roller:3.14.2

#REQ:gtk3
#REQ:itstool
#REC:desktop-file-utils
#REC:json-glib
#REC:libarchive
#REC:libnotify
#REC:nautilus
#OPT:unrar
#OPT:unzip
#OPT:zip


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/file-roller/3.14/file-roller-3.14.2.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/file-roller/file-roller-3.14.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/file-roller/file-roller-3.14.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/file-roller/file-roller-3.14.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/file-roller/file-roller-3.14.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/file-roller/3.14/file-roller-3.14.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/file-roller/file-roller-3.14.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/file-roller/3.14/file-roller-3.14.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr        \
            --disable-packagekit \
            --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod -v 755 /usr/libexec/file-roller/isoinfo.sh

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "file-roller=>`date`" | sudo tee -a $INSTALLED_LIST

