#!/bin/bash

# Create SSL Self Signed Certificate
if [ ! -f /etc/ssl/certs/nginx-selfsigned.crt ] || [ ! -f /etc/ssl/private/nginx-selfsigned.key ]; then
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
	openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
else
	echo "SSL CERTIFICATES ALREADY EXIST"
fi
