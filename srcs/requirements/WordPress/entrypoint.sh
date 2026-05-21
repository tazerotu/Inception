#!/bin/bash
set -e

echo "Waiting for MariaDB..."
until mysqladmin ping -h mariadb --silent 2>/dev/null; do
    sleep 2
done
echo "MariaDB is ready."

cd /var/www/html

if [ ! -f wp-login.php ]; then
    wp core download --allow-root

    wp config create \
        --allow-root \
        --dbname="${SQL_DATABASE}" \
        --dbuser="${SQL_USER}" \
        --dbpass="${SQL_PASSWORD}" \
        --dbhost=mariadb \
        --url="${WORDPRESS_URL}"

    wp core install \
        --allow-root \
        --url="${WORDPRESS_URL}" \
        --title="Inception" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASS}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --skip-email

    wp user create \
        --allow-root \
        "${WORDPRESS_USER}" "${WORDPRESS_USER_EMAIL}" \
        --user_pass="${WORDPRESS_USER_PASS}" \
        --role=subscriber
fi

# Configure php-fpm to listen on TCP instead of Unix socket
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:9000|' \
    /etc/php/7.4/fpm/pool.d/www.conf

mkdir -p /run/php

exec /usr/sbin/php-fpm7.4 -F