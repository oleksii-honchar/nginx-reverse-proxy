#!/bin/sh
DOCKER_LOG_PIPE=/var/log/docker-pipe

mkfifo $DOCKER_LOG_PIPE

cat < $DOCKER_LOG_PIPE > /dev/stdout &

/usr/sbin/crond -l 9

/usr/local/bin/nrp-cli -config=/etc/nrp.yaml -log-level=debug

exec "$@"