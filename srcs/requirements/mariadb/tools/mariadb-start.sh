#!/bin/sh
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    mariadb-start.sh                                   :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jmakkone <jmakkone@student.hive.fi>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/14 02:00:31 by jmakkone          #+#    #+#              #
#    Updated: 2025/03/14 02:00:31 by jmakkone         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

set -e

if ! grep -q "bind-address" /etc/my.cnf.d/mariadb-server.cnf 2>/dev/null; then
    echo "Configuring MariaDB to allow external connections..."
    cat <<EOF >> /etc/my.cnf.d/mariadb-server.cnf
[mysqld]
bind-address = 0.0.0.0
skip-networking = 0
EOF
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --datadir=/var/lib/mysql --skip-test-db --user=mysql --group=mysql > /dev/null 2>&1

    echo "Starting temporary MariaDB instance..."
    mysqld_safe &
    TEMP_PID=$!

    echo "Waiting for MariaDB to start..."
    until mysqladmin ping -u root --silent --protocol=socket; do
        sleep 1
    done

    echo "MariaDB started. Creating database and users..."
    mysql --protocol=socket -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF

    echo "Shutting down temporary MariaDB instance..."
    mysqladmin shutdown -u root --protocol=socket
    echo "Database initialization completed."
fi

echo "Starting MariaDB server..."
exec mariadbd --user=mysql --skip_networking=0 --datadir=/var/lib/mysql  --bind-address=0.0.0.0 --port=${MYSQL_PORT}
