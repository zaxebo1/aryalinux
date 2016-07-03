#!/bin/bash

set -e
set +h

RED='\033[0;31m'
NC='\033[0m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'

clear
cat asciiart
echo "Build/Installation Information:"
echo "Here are the devices attached to this system:"
echo -e "${BLUE}"
fdisk -l | grep "^Disk" | grep -v "identifier"
echo -e "${NC}"
read -p "Enter device name e.g. /dev/sda : " DEV_NAME
echo ""
echo "Here are the partitions in $DEV_NAME:"
echo -e "${BLUE}"
fdisk -l $DEV_NAME | grep "^$DEV_NAME"
echo -e "${RED}"
echo "Please enter different partition names for root and swap and home."
echo "If you do not want swap or home partitions, simply press enter."
echo -e "${NC}"
read -p "Enter the root partition e.g. /dev/sda10 : " ROOT_PART
read -p "Enter the swap partition e.g. /dev/sda11 : " SWAP_PART
read -p "Enter the home partition e.g. /dev/sda12 : " HOME_PART

clear
cat asciiart

echo "Computer and User Information:"
read -p "Enter the hostname(Computer name) : " HOST_NAME
read -p "Enter your full name : " FULLNAME
read -p "Enter the username for $FULLNAME : " USERNAME
read -p "Enter the domain name(Domain to which this computer would be added) e.g. aryalinux.org : " DOMAIN_NAME

clear
cat asciiart

echo "General Information about building:"
read -p "Enter locale e.g. en_IN.utf8 : " LOCALE
read -p "Do you have a US-English Keyboard? (y/n) : " USENG_KB
if [ "x$USENG_KB" != "xy" ] && [ "X$USENG_KB" != "XY" ]
then

read -p "Enter the keymap : " CONSOLEKEYMAP
read -p "Enter the font : " CONSOLEFONT

else

CONSOLEKEYMAP="us"

fi

read -p "Enter paper size (A4/letter) : " PAPER_SIZE
read -p "Do you want to build using multiple processors? (y/n) : " MULTICORE

echo "Enter the root password: "
read -s ROOT_PASSWORD
echo "Re-type the root password: "
read -s ROOT_PASSWORD1

if [ "$ROOT_PASSWORD" != "$ROOT_PASSWORD1" ]
then
	echo "Passwords do not match. Cannot continue. Exiting..."
	exit
fi

echo "Enter the password for $USERNAME: "
read -s USER_PASSWORD
echo "Re-type the password for $USERNAME: "
read -s USER_PASSWORD1

if [ "$USER_PASSWORD" != "$USER_PASSWORD1" ]
then
	echo "Passwords do not match. Cannot continue. Exiting..."
	exit
fi

clear
cat asciiart

TIMEZONE=`tzselect`

cat > build-properties << EOF
DEV_NAME="$DEV_NAME"
ROOT_PART="$ROOT_PART"
SWAP_PART="$SWAP_PART"
HOME_PART="$HOME_PART"
OS_NAME="AryaLinux"
OS_CODENAME="Saavan"
OS_VERSION="2016.07"
LOCALE="$LOCALE"
PAPER_SIZE="$PAPER_SIZE"
HOST_NAME="$HOST_NAME"
TIMEZONE="$TIMEZONE"
DOMAIN_NAME="$DOMAIN_NAME"
MULTICORE="$MULTICORE"
FULLNAME="$FULLNAME"
USERNAME="$USERNAME"
CONSOLEKEYMAP="$CONSOLEKEYMAP"
CONSOLEFONT="$CONSOLEFONT"
ROOT_PASSWORD="$ROOT_PASSWORD"
USER_PASSWORD="$USER_PASSWORD"
SCREEN_RES="`xrandr | fgrep '*' | tr -s " " | cut -d ' ' -f2`"
EOF

clear
cat asciiart

cat build-properties | grep -v "OS_" | grep -v "SCREEN_RES" | grep -v "_PASSWORD"
echo ""
read -p "Shall I proceed with these inputs? (y/n) " PROCEED
if [ "x$PROCEED" == "xy" ] || [ "X$PROCEED" == "XY" ]
then
	echo "Starting the build process..."
elif [ "x$PROCEED" == "xn" ] || [ "X$PROCEED" == "XN" ]
then
	echo "Exiting..."
	exit
else
	echo "Invalid Input. Aborting...."
	exit
fi

. ./build-properties

mkfs -v -t ext4 $ROOT_PART

export LFS=/mnt/lfs

mkdir -pv $LFS
mount -v -t ext4 $ROOT_PART $LFS

if [ "$HOME_PART" != "" ]
then
	mkdir -v $LFS/home
	mount -v -t ext4 $HOME_PART $LFS/home
fi


if [ "$SWAP_PART" != "" ]
then
	mkswap $SWAP_PART
	/sbin/swapon -v $SWAP_PART
fi

mkdir -v $LFS/sources
mkdir -v $LFS/sources/logs
chmod -Rv a+wt $LFS/sources
if [ -d ../sources ]
then
	cp ../sources/* $LFS/sources/
fi

rm -rf /sources
ln -svf $LFS/sources /
chmod -R a+rw /sources

rm -rf /tools
mkdir -v $LFS/tools
ln -sv $LFS/tools /

if grep "lfs" /etc/passwd &> /dev/null
then
	userdel -r lfs &> /dev/null
fi

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

chown -v lfs $LFS/tools
chown -v lfs $LFS/sources

chmod a+x *.sh
chmod a+x resume
chmod a+x toolchain/*.sh
chmod a+x final-system/*.sh

cp -r * /home/lfs/
cp -r * /sources
chown -R lfs:lfs /home/lfs/*

chmod a+x /home/lfs/*.sh

clear
echo "Entering lfs user. Please execute 2.sh by entering the following command below:"
echo -e "${ORANGE}"
echo "./2.sh"
echo -e "${NC}"

cat > /home/lfs/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > /home/lfs/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
EOF

su - lfs

chown -R root:root $LFS/tools

mkdir -pv $LFS/{dev,proc,sys,run}

mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3

mount -v --bind /dev $LFS/dev

mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

cp -v resume /tools/bin/resume
chmod a+x /tools/bin/resume

clear
echo "Would chroot into the toolchain."
echo "To continue enter the following command below:"
echo -e "${ORANGE}"
echo "resume"
echo -e "${NC}"

chroot "$LFS" /tools/bin/env -i \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='\u:\w\$ '              \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h

rm -rf /tmp/*

clear
echo "Once again chrooting to build the kernel and install bootloader"
echo "Please change to the /sources directory and execute 4.sh by entering the following command below:"
echo -e "${ORANGE}"
echo "cd /sources"
echo "./4.sh"
echo -e "${NC}"

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash --login +h

echo "Cleaning up..."

rm ./build-properties
cp $LFS/sources/build-properties $LFS/sources/props
grep -v "_PASSWORD" $LFS/sources/props > $LFS/sources/build-properties

