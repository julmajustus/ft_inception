#!/bin/sh

# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    start-redis.sh                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jmakkone <jmakkone@student.hive.fi>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/15 20:59:27 by jmakkone          #+#    #+#              #
#    Updated: 2025/03/15 20:59:27 by jmakkone         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

set -e

CONFIG_FILE="/etc/redis.conf"

if grep -q "^# maxmemory " "$CONFIG_FILE"; then
    sed -i 's/^# maxmemory .*/maxmemory 512mb/' "$CONFIG_FILE"
fi

if grep -q "^# maxmemory-policy " "$CONFIG_FILE"; then
    sed -i 's/^# maxmemory-policy .*/maxmemory-policy allkeys-lru/' "$CONFIG_FILE"
fi

if grep -q "^protected-mode " "$CONFIG_FILE"; then
    sed -i 's/^protected-mode .*/protected-mode no/' "$CONFIG_FILE"
fi

if grep -q "^bind " "$CONFIG_FILE"; then
    sed -i 's/^bind .*/bind 0.0.0.0/' "$CONFIG_FILE"
else
    echo "bind 0.0.0.0" >> "$CONFIG_FILE"
fi

if [ -n "$WP_REDIS_PASSWORD" ]; then
  if grep -q "^# requirepass " "$CONFIG_FILE"; then
      sed -i "s/^# requirepass .*/requirepass $WP_REDIS_PASSWORD/" "$CONFIG_FILE"
  else
      echo "requirepass $WP_REDIS_PASSWORD" >> "$CONFIG_FILE"
  fi
fi

exec redis-server "$CONFIG_FILE"
