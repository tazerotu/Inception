FROM debian:11

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/sites-available/default
COPY entrypoint.sh /entrypoint.sh
COPY static.html /var/www/html/static.html
RUN chmod +x /entrypoint.sh

EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]