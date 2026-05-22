FROM debian:11

RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i 's/bind-address.*=.*/bind-address = 0.0.0.0/' \
    /etc/mysql/mariadb.conf.d/50-server.cnf

COPY entrypoint.sh /entrypoint.sh
COPY mariadb.cnf /etc/mysql/mariadb.conf.d/99-custom.cnf
RUN chmod +x /entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]