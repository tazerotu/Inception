#!/bin/bash
set -e

# Create SSL directory
mkdir -p /etc/nginx/ssl

# Generate self-signed certificate if not present
if [ ! -f /etc/nginx/ssl/cert.pem ]; then
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/key.pem \
        -out /etc/nginx/ssl/cert.pem \
        -subj "/C=FR/ST=PACA/L=Nice/O=42/CN=${DOMAIN_NAME}"
fi

exec nginx -g 'daemon off;'