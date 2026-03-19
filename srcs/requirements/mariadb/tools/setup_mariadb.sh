#!/bin/bash
set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    mysqld_safe --skip-networking &
    pid="$!"

    echo "Waiting for MariaDB to start..."
    while ! mysqladmin ping --silent; do
        sleep 1
    done

    echo "Creating database and users..."
    mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait "$pid"
fi

echo "Starting MariaDB in foreground..."
exec mysqld_safe