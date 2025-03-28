#!/bin/sh

# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    start-nginx.sh                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jmakkone <jmakkone@student.hive.fi>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/14 02:55:32 by jmakkone          #+#    #+#              #
#    Updated: 2025/03/14 02:55:32 by jmakkone         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

set -e 

# Define paths for the SSL key and certificate
SSL_DIR="/etc/nginx/ssl"
KEY_FILE="${SSL_DIR}/selfsigned.key"
CERT_FILE="${SSL_DIR}/selfsigned.crt"

sed -i "s/\${DOMAIN_NAME}/$DOMAIN_NAME/g" /etc/nginx/nginx.conf
sed -i "s/\${DOMAIN_NAME}/$DOMAIN_NAME/g" /etc/nginx/http.d/default.conf

if [ ! -f "$KEY_FILE" ] || [ ! -f "$CERT_FILE" ]; then
    echo "SSL key or certificate not found. Generating self-signed SSL certificate..."
    mkdir -p "$SSL_DIR"
    openssl req -x509 -nodes -days 365 \
        -subj "/CN=${DOMAIN_NAME}" \
        -newkey rsa:2048 \
        -keyout "$KEY_FILE" \
        -out "$CERT_FILE"
fi

echo "Starting nginx..."
exec nginx -g 'daemon off;'
