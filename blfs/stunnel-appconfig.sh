#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 51 stunnel &&
useradd -c "stunnel Daemon" -d /var/lib/stunnel \
        -g stunnel -s /bin/false -u 51 stunnel

}


postinstall()
{
echo "#"
}


$1