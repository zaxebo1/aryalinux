#!/bin/bash
set -e
set +h

useradd -c "Print Service User" -d /var/spool/cups -g lp -s /bin/false -u 9 lp

groupadd -g 19 lpadmin

