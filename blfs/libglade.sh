#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libglade:2.6.4

#REQ:libxml2
#REQ:gtk2
#OPT:python2
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/libglade/2.6/libglade-2.6.4.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libglade/libglade-2.6.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libglade/libglade-2.6.4.tar.bz2 || wget -nc http://ftp.gnome.org/pub/gnome/sources/libglade/2.6/libglade-2.6.4.tar.bz2 || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libglade/2.6/libglade-2.6.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libglade/libglade-2.6.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libglade/libglade-2.6.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libglade/libglade-2.6.4.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i '/DG_DISABLE_DEPRECATED/d' glade/Makefile.in &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libglade=>`date`" | sudo tee -a $INSTALLED_LIST

