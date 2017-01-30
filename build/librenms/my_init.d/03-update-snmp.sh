#!/bin/bash

sed -i "s|RANDOMSTRINGGOESHERE|${MYCNF_SNMP_COMMUNITY}|" /etc/snmp/snmpd.conf
