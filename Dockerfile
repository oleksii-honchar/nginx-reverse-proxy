# syntax = docker/dockerfile:experimental
FROM tuiteraz/nginx-more:1.27.2-1.2.0

# NRP image name and version to print on start
ARG IMAGE_VERSION
ARG IMAGE_NAME
ENV IMAGE_VERSION=$IMAGE_VERSION
ENV IMAGE_NAME=$IMAGE_NAME

# RUN apk add --no-cache certbot py3-pip dnsmasq-dnssec supervisor squid bash openrc && \
#     pip3 install --upgrade pyOpenSSL && \
#     apk del py3-pip
RUN apk add --no-cache certbot openssl dnsmasq-dnssec supervisor squid bash openrc

# Supervisor
RUN mkdir /etc/supervisor
COPY ./scripts/log-processor.bash /usr/local/bin/log-processor
RUN chmod +x /usr/local/bin/log-processor

# Squid
ENV SQUID_LOGS_DIR="/var/log/squid"

RUN mkdir -p $SQUID_LOGS_DIR && \
  chown -R squid:squid $SQUID_LOGS_DIR && \
  chmod -R 755 $SQUID_LOGS_DIR

# Certbot
RUN mkdir -p /etc/letsencrypt

# Nginx config
COPY ./configs/nginx /etc/nginx

RUN mkdir /etc/nrp
ENV NRP_CLI_VER=v0.10.2
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