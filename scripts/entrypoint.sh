#!/bin/sh

echo "${IMAGE_NAME}:${IMAGE_VERSION}"

# Docker
DOCKER_LOG_PIPE=/var/log/docker-pipe
mkfifo $DOCKER_LOG_PIPE
cat < $DOCKER_LOG_PIPE > /dev/stdout &

# Squid
SQUID_ACCESS_LOG_FILE=/var/log/squid/squid_access_log_pipe
SQUID_CACHE_LOG_FILE=/var/log/squid/squid_cache_log_pipe

mkfifo $SQUID_ACCESS_LOG_FILE
mkfifo $SQUID_CACHE_LOG_FILE
chown -R squid:squid $SQUID_ACCESS_LOG_FILE
chown -R squid:squid $SQUID_CACHE_LOG_FILE

cat < $SQUID_ACCESS_LOG_FILE >/dev/stdout &
cat < $SQUID_CACHE_LOG_FILE >/dev/stdout &

# Cron
/usr/sbin/crond -l 9

# nrp-cli - generate nginx, squid & dnsmasq configs, also request SSL cert if needed
value="${CERTBOT_WAIT:-false}"
level="${LOG_LEVEL:-info}"
/usr/local/bin/nrp-cli -config=/etc/nrp.yaml -log-level=$level -check-and-update-public-ip -force
/usr/local/bin/nrp-cli -config=/etc/nrp.yaml -log-level=$level -certbot-wait=$value

exec "$@"