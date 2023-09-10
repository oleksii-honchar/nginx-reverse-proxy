FROM tuiteraz/nginx-more:latest

ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apk add --no-cache \
    certbot py3-pip \
    supervisor \
    bash


# Certbot
RUN pip3 install --upgrade pyOpenSSL
RUN apk del py3-pip
RUN mkdir -p /etc/letsencrypt/acme-challenge

# Supervisor
RUN mkdir -p /etc/supervisord
COPY ./supervisord/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./supervisord/prefix-log.bash /usr/local/bin/prefix-log
COPY ./supervisord/prefix-log-nginx.bash /usr/local/bin/prefix-log-nginx
COPY ./supervisord/prefix-log-certbot.bash /usr/local/bin/prefix-log-certbot
RUN chmod +x /usr/local/bin/prefix-log /usr/local/bin/prefix-log-nginx /usr/local/bin/prefix-log-certbot

# Cron
COPY ./cron/crontab /etc/crontabs/root
RUN chmod 0644 /etc/crontabs/root

EXPOSE 80 443

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]