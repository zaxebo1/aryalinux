#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 21 gdm &&
useradd -c "GDM Daemon Owner" -d /var/lib/gdm -u 21 \
        -g gdm -s /bin/false gdm

}


postinstall()
{
echo "#"
}


$1