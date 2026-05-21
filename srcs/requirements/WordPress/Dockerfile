FROM debian:11

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-curl \
    php7.4-gd \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-zip \
    wget \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    -O /usr/local/bin/wp \
    && chmod +x /usr/local/bin/wp

RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]