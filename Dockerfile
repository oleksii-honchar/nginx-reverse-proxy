# syntax = docker/dockerfile:experimental
FROM tuiteraz/nginx-more:1.25.2-2

RUN apk add --no-cache certbot py3-pip dnsmasq-dnssec supervisor squid bash openrc && \
    pip3 install --upgrade pyOpenSSL && \
    apk del py3-pip

# Supervisor
RUN mkdir /etc/supervisor
COPY ./scripts/prefix-log.bash /usr/local/bin/prefix-log
COPY ./scripts/prefix-log-nginx.bash /usr/local/bin/prefix-log-nginx
RUN chmod +x /usr/local/bin/prefix-log
RUN chmod +x /usr/local/bin/prefix-log-nginx

# Squid
ENV SQUID_LOGS_DIR="/var/log/squid"

RUN mkdir -p $SQUID_LOGS_DIR && \
    chown -R squid:squid $SQUID_LOGS_DIR && \
    chmod -R 755 $SQUID_LOGS_DIR

# Certbot
RUN mkdir -p /etc/letsencrypt

COPY ./scripts/prefix-log-certbot.bash /usr/local/bin/prefix-log-certbot
RUN chmod +x /usr/local/bin/prefix-log-certbot

# Nginx config
COPY ./configs/nginx /etc/nginx

# nrp-cli
COPY ./scripts/prefix-log-nrp.bash /usr/local/bin/prefix-log-nrp
RUN chmod +x /usr/local/bin/prefix-log-nrp

RUN mkdir /etc/nrp
ENV NRP_CLI_VER=v0.5.0
RUN wget https://github.com/oleksii-honchar/nrp-cli/releases/download/$NRP_CLI_VER/nrp-cli-linux-$NRP_CLI_VER.tar.gz && \
    tar xzvf nrp-cli-linux-$NRP_CLI_VER.tar.gz && \
    cp ./nrp-cli-linux /usr/local/bin/nrp-cli &&\
    chmod +x /usr/local/bin/nrp-cli &&\
    rm nrp-cli-linux-$NRP_CLI_VER.tar.gz nrp-cli-linux

#---

EXPOSE 53 53/udp 80 443 3128 

COPY ./scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# CMD ["/usr/sbin/nginx"]
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]