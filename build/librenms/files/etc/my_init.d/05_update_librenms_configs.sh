#!/bin/bash

# Configuration File that if Exists will append to existing config.php

BASECONFIG=/configs/librenms/config.php
CUSTOMCONFIG=/configs/librenms/append.config.php
LIBRENMSCONFIG=/opt/librenms/config.php
LIBRENMSENV=/opt/librenms/environment_librenms

rm -f ${LIBRENMSENV}

# Include Mounted Config File if it exists and append it to existing config file in container
if [ -f ${CUSTOMCONFIG} ]; then
	echo "APPENDING TO BASECONFIG AT ${BASECONFIG}"
	echo include ${CUSTOMCONFIG} >> ${LIBRENMSCONFIG}
fi

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
LIBRENMSCRON=/opt/cron.d/librenms

sed -i "s| ${LIBRENMSDIR}| ${LIBRENMSENV};${LIBRENMSDIR}|" ${LIBRENMSCRON}
