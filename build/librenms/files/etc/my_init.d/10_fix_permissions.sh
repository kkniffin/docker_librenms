#!/bin/bash

echo "SETTING PERMISSIONS ON DIRECTORIES"
chown librenms.librenms -R /opt/librenms
chmod u+s /usr/bin/fping
chmod u+s /usr/bin/fping6
chmod 775 /opt/librenms/rrd/
ls -alh /opt/librenms/rrd
