#!/bin/bash

BASECONFIG=/configs/config.php
CUSTOMCONFIG=/configs/config.custom.php
LIBRENMSCONFIG=/opt/librenms/config.php


if [ -f ${BASECONFIG} ]; then
	echo "COPYING BASECONFIG FROM ${BASECONFIG}"
	cp ${BASECONFIG} ${LIBRENMSCONFIG}
fi

if [ -f ${CUSTOMCONFIG} ]; then
	echo "APPENDING TO BASECONFIG AT ${BASECONFIG}"
	cat ${CUSTOMCONFIG} >> ${LIBRENMSCONFIG}
fi
