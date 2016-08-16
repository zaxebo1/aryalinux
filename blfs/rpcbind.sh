#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:rpcbind:0.2.3

#REQ:libtirpc


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/rpcbind/rpcbind-0.2.3.tar.bz2

wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/rpcbind-0.2.3-tirpc_fix-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/rpcbind/rpcbind-0.2.3-tirpc_fix-1.patch
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/rpcbind/rpcbind-0.2.3.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/rpcbind/rpcbind-0.2.3.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/rpcbind/rpcbind-0.2.3.tar.bz2 || wget -nc http://downloads.sourceforge.net/rpcbind/rpcbind-0.2.3.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/rpcbind/rpcbind-0.2.3.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/rpcbind/rpcbind-0.2.3.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 28 rpc &&
useradd -c "RPC Bind Daemon Owner" -d /dev/null -g rpc \
        -s /bin/false -u 28 rpc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


sed -i "/servname/s:rpcbind:sunrpc:" src/rpcbind.c &&


patch -Np1 -i ../rpcbind-0.2.3-tirpc_fix-1.patch &&
./configure --prefix=/usr  \
            --bindir=/sbin \
            --with-rpcuser=rpc &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.08/blfs-systemd-units-20160602.tar.xz -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-rpcbind

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602.tar.xz
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "rpcbind=>`date`" | sudo tee -a $INSTALLED_LIST

