#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The lxqt-panel package contains abr3ak lightweight X11 desktop panel.br3ak"
SECTION="lxqt"
VERSION=0.11.0
NAME="lxqt-panel"

#REQ:lxqt-kguiaddons
#REQ:lxqt-solid
#REQ:lxqt-globalkeys
#REQ:libdbusmenu-qt
#REQ:liblxqt
#REQ:lxmenu-data
#REQ:menu-cache
#REQ:kframeworks5
#REC:alsa-lib
#REC:pulseaudio
#REC:libstatgrab
#REC:libsysstat
#REC:libxkbcommon
#REC:lm_sensors
#OPT:git
#OPT:lxqt-l10n


cd $SOURCE_DIR

URL=http://downloads.lxqt.org/lxqt/0.11.0/lxqt-panel-0.11.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxqt-panel/lxqt-panel-0.11.0.tar.xz || wget -nc http://downloads.lxqt.org/lxqt/0.11.0/lxqt-panel-0.11.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-panel/lxqt-panel-0.11.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-panel/lxqt-panel-0.11.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-panel/lxqt-panel-0.11.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-panel/lxqt-panel-0.11.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

whoami > /tmp/currentuser

mkdir -v build &&
cd       build &&
cmake -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DCMAKE_BUILD_TYPE=Release          \
      -DPULL_TRANSLATIONS=no              \
      -DCMAKE_INSTALL_LIBDIR=lib          \
      ..                                  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
