FROM debian:bullseye

RUN apt update && apt upgrade -y &&\
    apt install -y mariadb-server &&\
    apt clean && rm -rf /var/lib/apt/lists/*

COPY tools/setup_mariadb.sh /setup_mariadb.sh

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN chmod +x /setup_mariadb.sh

EXPOSE 3306

CMD ["/setup_mariadb.sh"]