#!/bin/bash
set -e

# Create the socket directory
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Initialize data directory if empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

# Bootstrap: create DB, user, set root password
mysqld --user=mysql --bootstrap << EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

exec mysqld --user=mysql