#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:fireflysung:1.3.0



cd $SOURCE_DIR

URL=http://sourceforge.jp/projects/sfnet_chinesepuppy/downloads/ChineseSupport/Fonts/fireflysung-1.3.0.tar.gz

wget -nc http://sourceforge.jp/projects/sfnet_chinesepuppy/downloads/ChineseSupport/Fonts/fireflysung-1.3.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
usermod -a -G video <em class="replaceable"><code><username></em>

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


DRI_PRIME=1 glxinfo | egrep "(OpenGL vendor|OpenGL renderer|OpenGL version)"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d -m755 /usr/share/fonts/dejavu &&
install -v -m644 *.ttf /usr/share/fonts/dejavu &&
fc-cache -v /usr/share/fonts/dejavu

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cat > /etc/X11/xorg.conf.d/xkb-defaults.conf << "EOF"
Section "InputClass"
    Identifier "XKB Defaults"
    MatchIsKeyboard "yes"
    Option "XkbOptions" "terminate:ctrl_alt_bksp"
EndSection
EOF


cat > /etc/X11/xorg.conf.d/videocard-0.conf << "EOF"
Section "Device"
    Identifier  "Videocard0"
    Driver      "radeon"
    VendorName  "Videocard vendor"
    BoardName   "ATI Radeon 7500"
    Option      "NoAccel" "true"
EndSection
EOF


cat > /etc/X11/xorg.conf.d/server-layout.conf << "EOF"
Section "ServerLayout"
    Identifier     "DefaultLayout"
    Screen      0  "Screen0" 0 0
    Screen      1  "Screen1" LeftOf "Screen0"
    Option         "Xinerama"
EndSection
EOF


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "xorg-config=>`date`" | sudo tee -a $INSTALLED_LIST
