#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="arc-gtk-theme"
DESCRIPTION="A beautiful and modern flat GTK+ theme"
VERSION="SVN-`date -I`"

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

git clone https://github.com/horst3180/arc-theme --depth 1 && cd arc-theme
./autogen.sh --prefix=/usr
sudo make install

cd $SOURCE_DIR
rm -rf arc-theme

git clone https://github.com/horst3180/arc-firefox-theme && cd arc-firefox-theme
./autogen.sh --prefix=/usr
sudo make install

cd $SOURCE_DIR
rm -rf arc-firefox-theme

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
