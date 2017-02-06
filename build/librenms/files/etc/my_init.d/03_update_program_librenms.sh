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


NAGIOSPLUG_BASEURL="http://nagios-plugins.org/download/"
NAGIOSPLUG_LATEST="$(curl -s 'http://nagios-plugins.org/download/' | egrep -o 'href="nagios-plugins-[0-9]+\.[0-9]+\.[0-9]+.tar.gz' | sed 's/^href="//' | sort -t. -rn | uniq | head -1)"
NAGIOSPLUG_DIR=/usr/lib/nagios/plugins

echo "UPDATING NAGIONS PLUGINS FROM ${NAGIOSPLUG_BASEURL}/${NAGIOSPLUG_LATEST}"
mkdir -p ${NAGIOSPLUG_DIR}
cd /tmp
wget ${NAGIOSPLUG_BASEURL}/${NAGIOSPLUG_LATEST} ./
tar zxvf ./${NAGIOSPLUG_LATEST}
cd nagios-plugins-*
./configure --prefix=/tmp --with-nagios-user=librenms --with-nagios-group=librenms --libexecdir=${NAGIOSPLUG_DIR}
make
make install
chmod -R 755 ${NAGIOSPLUG_DIR}
rm -f ./${NAGIOSPLUG_LATEST}
