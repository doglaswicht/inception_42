#!/bin/bash
set -e

mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=CH/ST=Vaud/L=Lausanne/O=42/OU=42/CN=dleite-b.42.fr"

nginx -g "daemon off;"