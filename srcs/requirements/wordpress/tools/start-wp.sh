#!/bin/sh
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    start-wp.sh                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jmakkone <jmakkone@student.hive.fi>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/14 02:28:11 by jmakkone          #+#    #+#              #
#    Updated: 2025/03/14 02:28:11 by jmakkone         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

set -e

echo "Waiting for MariaDB at ${MYSQL_HOSTNAME}:$MYSQL_PORT..."
while ! nc -z "$MYSQL_HOSTNAME" "$MYSQL_PORT"; do
    sleep 1
done
echo "MariaDB is available."

echo "Waiting for redis cache at ${WP_REDIS_HOSTNAME}:$WP_REDIS_PORT..."
while ! nc -z "$WP_REDIS_HOSTNAME" "$WP_REDIS_PORT"; do
    sleep 1
done
echo "Redis cache is available."

WP_CONFIG="/var/www/html/wp-config.php"
WP_SAMPLE="/var/www/html/wp-config-sample.php"

if [ ! -f "$WP_CONFIG" ]; then
    echo "Configuring WordPress: creating wp-config.php..."
    cp "$WP_SAMPLE" "$WP_CONFIG"

    echo "Updating database settings in wp-config.php..."
    sed -i "s/database_name_here/${MYSQL_DATABASE}/g" "$WP_CONFIG"
    sed -i "s/username_here/${MYSQL_USER}/g" "$WP_CONFIG"
    sed -i "s/password_here/${MYSQL_PASSWORD}/g" "$WP_CONFIG"
    sed -i "s/localhost/${MYSQL_HOSTNAME}/g" "$WP_CONFIG"
	sed -i '/\/\* Add any custom values between this line and the "stop editing" line\. \*\//a define('"'"'FS_METHOD'"'"', '"'"'direct'"'"');' "$WP_CONFIG"
fi

chown -R www-data:www-data /var/www/html 
cd /var/www/html
wp core install --url=$WP_URL --title="$WP_TITLE" --admin_user=$WP_USER --admin_password=$WP_PASSWORD --admin_email=$WP_EMAIL --allow-root
wp config set WP_REDIS_PASSWORD $WP_REDIS_PASSWORD --allow-root
wp config set WP_REDIS_HOST $WP_REDIS_HOSTNAME --allow-root #I put --allowroot because i am on the root user on my VM
wp config set WP_REDIS_PORT $WP_REDIS_PORT --raw --allow-root
wp config set WP_CACHE_KEY_SALT $DOMAIN_NAME --allow-root
wp config set WP_REDIS_CLIENT phpredis --allow-root
wp plugin install redis-cache --activate --allow-root
wp plugin update --all --allow-root
wp redis enable --allow-root

#wp config set WP_DEBUG true --allow-root
#wp config set WP_DEBUG_LOG true --allow-root

echo "Starting PHP-FPM..."
exec php-fpm82 -F
