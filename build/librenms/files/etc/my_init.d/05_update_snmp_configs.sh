#!/bin/bash

echo '##################################################'
echo '##### Updating SNMP Configuration'
echo '##################################################'

SNMPDCONFFILE=/etc/snmp/snmpd.conf
SNMPDCOMMUNITY=${MYCNF_SNMP_COMMUNITY}

echo "SNMPD: Changing Community to ${SNMPDCOMMUNITY}"
sed -i "s|RANDOMSTRINGGOESHERE|${SNMPDCOMMUNITY}|" ${SNMPDCONFFILE}
