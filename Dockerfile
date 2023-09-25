# syntax = docker/dockerfile:experimental
FROM tuiteraz/nginx-more:latest

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

EXPOSE 80 443

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY ./nrp-cli-linux /usr/local/bin/nrp-cli
RUN chmod +x /usr/local/bin/nrp-cli

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/sbin/nginx"]