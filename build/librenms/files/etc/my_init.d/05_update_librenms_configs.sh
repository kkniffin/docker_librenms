#!/bin/bash

BASECONFIG=/configs/librenms/config.php
CUSTOMCONFIG=/configs/librenms/config.custom.php
LIBRENMSCONFIG=/opt/librenms/config.php


#if [ -f ${BASECONFIG} ]; then
#	echo "COPYING BASECONFIG FROM ${BASECONFIG}"
#	cp ${BASECONFIG} ${LIBRENMSCONFIG}
#fi

# Include Mounted Config File if it exists and append it to existing config file in container
if [ -f ${CUSTOMCONFIG} ]; then
	echo "APPENDING TO BASECONFIG AT ${BASECONFIG}"
	echo include ${CUSTOMCONFIG} >> ${LIBRENMSCONFIG}
fi
