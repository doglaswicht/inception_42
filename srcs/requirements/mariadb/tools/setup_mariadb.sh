#!/bin/bash
set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

echo "Starting MariaDB setup..."

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database files..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

echo "Starting temporary MariaDB..."
mysqld_safe --skip-networking &
pid="$!"

echo "Waiting for MariaDB to be ready..."
until mysqladmin ping --silent; do
    sleep 1
done

echo "Setting root password if needed..."
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';" || true

echo "Creating WordPress database if needed..."
mysql -u root -p"${DB_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"

echo "Creating WordPress user if needed..."
mysql -u root -p"${DB_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"

echo "Granting privileges..."
mysql -u root -p"${DB_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"

echo "Flushing privileges..."
mysql -u root -p"${DB_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

echo "Stopping temporary MariaDB..."
mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown
wait "$pid"

echo "Starting MariaDB in foreground..."
exec mysqld_safe