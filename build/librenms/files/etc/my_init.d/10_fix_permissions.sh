#!/bin/bash

echo '##################################################'
echo '##### Fixing Permissions On Directories'
echo '##################################################'


echo "PERMISSIONS: Setting Permissions On Directories"
chown librenms.librenms -R /opt/librenms
chmod u+s /usr/bin/fping
chmod u+s /usr/bin/fping6
chmod 775 /opt/librenms/rrd/
