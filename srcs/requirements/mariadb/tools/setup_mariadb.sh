#!/bin/bash
set -e

echo "MariaDB setup script starting..."

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

echo "MYSQL_DATABASE=$MYSQL_DATABASE"
echo "MYSQL_USER=$MYSQL_USER"

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

# On first boot root may have no password; on later boots the persisted DB requires it.
MYSQL_ROOT_ARGS=(-u root)
if ! mysql "${MYSQL_ROOT_ARGS[@]}" -e "SELECT 1;" >/dev/null 2>&1; then
    MYSQL_ROOT_ARGS=(-u root -p"${DB_ROOT_PASSWORD}")
fi

USER_EXISTS=$(mysql "${MYSQL_ROOT_ARGS[@]}" -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user='${MYSQL_USER}' AND host='%');")

if [ "$USER_EXISTS" = "0" ]; then
    echo "Creating database and user..."
    mysql "${MYSQL_ROOT_ARGS[@]}" -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
    mysql "${MYSQL_ROOT_ARGS[@]}" -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
    mysql "${MYSQL_ROOT_ARGS[@]}" -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
    mysql "${MYSQL_ROOT_ARGS[@]}" -e "FLUSH PRIVILEGES;"
else
    echo "User already exists, skipping creation."
fi

echo "Setting root password..."
mysql "${MYSQL_ROOT_ARGS[@]}" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"
mysql -u root -p"${DB_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

echo "Stopping temporary MariaDB..."
mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown
wait "$pid"

echo "Starting MariaDB in foreground..."
exec mysqld_safe