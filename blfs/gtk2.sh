#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gtk+:2.24.29

#REQ:atk
#REQ:gdk-pixbuf
#REQ:pango
#REC:hicolor-icon-theme
#OPT:cups
#OPT:docbook-utils
#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt
#OPT:gobject-introspection
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.29.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtk+/gtk+-2.24.29.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk+/gtk+-2.24.29.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.29.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtk+/gtk+-2.24.29.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtk+/gtk+-2.24.29.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk+/gtk+-2.24.29.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.29.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "s#l \(gtk-.*\).sgml#& -o \1#" docs/{faq,tutorial}/Makefile.in &&
./configure --prefix=/usr --sysconfdir=/etc                           &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-query-immodules-2.0 --update-cache

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cat > ~/.gtkrc-2.0 << "EOF"
include "/usr/share/themes/<em class="replaceable"><code>Adwaita</em>/gtk-2.0/gtkrc"
gtk-icon-theme-name = "<em class="replaceable"><code>Adwaita</em>"
EOF



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/gtk-2.0/gtkrc << "EOF"
include "/usr/share/themes/<em class="replaceable"><code>Clearlooks</em>/gtk-2.0/gtkrc"
gtk-icon-theme-name = "<em class="replaceable"><code>elementary</em>"
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gtk2=>`date`" | sudo tee -a $INSTALLED_LIST

