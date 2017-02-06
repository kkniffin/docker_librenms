#!/bin/bash

echo '##################################################'
echo '##### Updating LibreNMS Configuration'
echo '##################################################'


# Configuration File that if Exists will append to existing config.php

BASECONFIG=/configs/librenms/config.php
CUSTOMCONFIG=/configs/append.config.php
CONFIGDEFAULT=/configs_default/config.php
LIBRENMSCONFIG=/opt/librenms/config.php
LIBRENMSENV=/opt/librenms/librenms.env

# Remove Existing Enviroment file
rm -f ${LIBRENMSENV}

# Copy Default Config on Runtime
echo "LIBRENMS: COPYING DEFAULT CONFIG FROM ${CONFIGDEFAULT} to ${LIBENMSCONFIG}"
cp ${CONFIGDEFAULT} ${LIBRENMSCONFIG}

# Include Mounted Config File if it exists and append it to existing config file in container
echo "LIBRENMS: CHECKING IF ${CUSTOMCONFIG} EXISTS TO APPEND TO ${BASECONFIG}"
if [ -f ${CUSTOMCONFIG} ] && [[ ! $(egrep '#CUSTOMCONFIGSTART' $LIBRENMSCONFIG) ]]; then
	echo "LIBRENMS: CUSTOM CONFIG FOUND, APPENDING TO CONFIG AT ${BASECONFIG}"
	echo -e "\n# IMPORTING CONFIG FROM ${CUSTOMCONFIG}" >> ${LIBRENMSCONFIG}
	echo "#CUSTOMCONFIGSTART" >> ${LIBRENMSCONFIG}
	cat "${CUSTOMCONFIG}" >> ${LIBRENMSCONFIG}
	echo "#CUSTOMCONFIGEND" >> ${LIBRENMSCONFIG}
fi

echo "LIBRENMS: EXPORTING CONFIG VARIABLES TO ${LIBRENMSENV}"

# Export Environment Variables to File for Importing before running command

ENV_VARIABLEPREFIX=LIBRENMS_CONFIG_PHP_ # What environment variables will be prefixed with to denote use.

# Iterate Through Environment Variables and Output them to File for Importing before running commands
for ENVVARIABLE in `eval echo '${!'$ENV_VARIABLEPREFIX'*}'`
do
	# Get Value for Variable
        CONFIGVALUE="$(printenv $ENVVARIABLE)"
 	echo "export ${ENVVARIABLE}=${CONFIGVALUE}" >> ${LIBRENMSENV}
done

# Update Cron.d for LibreNMS to import Enviroment Variables

LIBRENMSDIR=/opt/librenms
LIBRENMSCRON=/etc/cron.d/librenms

echo "LIBRENMS: UPDATING CRONTAB AT ${LIBRENMSCRON}"

if [[ ! $(egrep "${LIBRENMSENV}" $LIBRENMSCRON) ]]; then
	sed -i "s| ${LIBRENMSDIR}| . ${LIBRENMSENV};${LIBRENMSDIR}|" ${LIBRENMSCRON}
fi

# Add Nagios Plugins Check
if [[ ! $(egrep 'check-services.php' $LIBRENMSCRON) ]]; then
        echo '*/5 * * * * librenms /opt/librenms/check-services.php >> /dev/null 2>&1' >> ${LIBRENMSCRON}
fi


