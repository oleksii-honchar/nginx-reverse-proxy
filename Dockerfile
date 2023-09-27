# syntax = docker/dockerfile:experimental
FROM tuiteraz/nginx-more:1.25.2

RUN apk add --no-cache \
    certbot py3-pip \
    tzdata \
    bash

# Certbot
RUN pip3 install --upgrade pyOpenSSL
RUN apk del py3-pip
RUN mkdir -p /etc/letsencrypt

# Prefixed logs for certbot commands
COPY ./prefix-log-certbot.bash /usr/local/bin/prefix-log-certbot
RUN chmod +x /usr/local/bin/prefix-log-certbot

# Cron
COPY ./cron/crontab /etc/crontabs/root
RUN chmod 0644 /etc/crontabs/root

# Nginx config
COPY ./nginx-config /etc/nginx

EXPOSE 80 443

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN wget https://github.com/oleksii-honchar/nrp-cli/releases/download/v0.2.0/nrp-cli-linux-v0.2.0.tar.gz && \
    tar xzvf nrp-cli-linux-v0.2.0.tar.gz && \
    cp ./nrp-cli-linux /usr/local/bin/nrp-cli &&\
    chmod +x /usr/local/bin/nrp-cli &&\
    rm nrp-cli-linux-v0.2.0.tar.gz nrp-cli-linux

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/sbin/nginx"]