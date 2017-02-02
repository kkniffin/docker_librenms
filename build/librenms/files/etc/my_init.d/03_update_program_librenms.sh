#!/bin/bash

echo '##################################################'
echo '##### Update LibreNMS from Git'
echo '##################################################'



if [[ ${LIBRENMS_AUTOUPDATE,,} = "true" ]]; then
	echo "UPDATING LIBRENMS...."
	cd /opt/librenms
	git pull
else
	echo "UPDATING LIBRENMS VIA GIT DISABLED"
fi
