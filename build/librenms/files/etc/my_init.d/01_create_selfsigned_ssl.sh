#!/bin/bash

##################################################
##### Create Self Signed SSL Certificate
##################################################


SELFSIGNEDCERT=/etc/ssl/certs/nginx-selfsigned.crt
SELFSIGNEDKEY=/etc/ssl/private/nginx-selfsigned.key
CERT_OUTFOLDER=/etc/ssl/certs
CERT_COUNTRY=US
CERT_STATE=TX
CERT_CITY=MyCity
CERT_ORG=MyORG
CERT_CN=librenms.example.com


# Create SSL Self Signed Certificate
if [ ! -f ${SELFSIGNEDCERT} ] || [ ! -f ${SELFSIGNEDKEY} ]; then
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=${CERT_COUNTRY}/ST=${CERT_STATE}/L=${CERT_CITY}/O=${CERT_ORG}/CN=${CERT_CN}" -keyout /etc/ssl/private/nginx-selfsigned.key -out ${CERT_OUTFOLDER}/nginx-selfsigned.crt
	openssl dhparam -out ${CERT_OUTFOLDER}/dhparam.pem 2048
else
	echo "SSL CERTIFICATES ALREADY EXIST"
fi
