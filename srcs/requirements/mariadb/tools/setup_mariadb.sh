#!/bin/bash
set -e

echo "MariaDB setup script starting..."

echo "MYSQL_DATABASE=$MYSQL_DATABASE"
echo "MYSQL_USER=$MYSQL_USER"
echo "MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD"

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

echo "Starting temporary MariaDB..."
mysqld_safe --skip-networking &
pid="$!"

echo "Waiting for temporary MariaDB..."
until mysqladmin ping --silent; do
    sleep 1
done

USER_EXISTS=$(mysql -u root -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user='${MYSQL_USER}' AND host='%');")

if [ "$USER_EXISTS" = "0" ]; then
    echo "Creating database and user..."
    mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
else
    echo "User already exists, skipping creation."
fi

echo "Setting root password..."
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

echo "Stopping temporary MariaDB..."
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
wait "$pid"

echo "Starting MariaDB in foreground..."
exec mysqld_safe