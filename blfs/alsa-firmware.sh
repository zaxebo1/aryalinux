#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The ALSA Firmware package containsbr3ak firmware for certain sound cards.br3ak"
SECTION="multimedia"
VERSION=1.0.29
NAME="alsa-firmware"

#REQ:alsa-tools


cd $SOURCE_DIR

URL=http://alsa.cybermirror.org/firmware/alsa-firmware-1.0.29.tar.bz2

if [ ! -z $URL ]
then
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/alsa-firmware/alsa-firmware-1.0.29.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/alsa-firmware/alsa-firmware-1.0.29.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/alsa-firmware/alsa-firmware-1.0.29.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-firmware/alsa-firmware-1.0.29.tar.bz2 || wget -nc ftp://ftp.alsa-project.org/pub/firmware/alsa-firmware-1.0.29.tar.bz2 || wget -nc http://alsa.cybermirror.org/firmware/alsa-firmware-1.0.29.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-firmware/alsa-firmware-1.0.29.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
