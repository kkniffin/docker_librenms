#!/bin/bash

if [[ ${LIBRENMS_AUTOUPDATE,,} = "true" ]]; then
	echo "UPDATING LIBRENMS...."
	cd /opt/librenms
	git pull
fi
