#!/bin/sh
DOCKER_LOG_PIPE=/var/log/docker-pipe

mkfifo $DOCKER_LOG_PIPE

cat < $DOCKER_LOG_PIPE >/dev/stdout &

/usr/sbin/crond -l 9

exec "$@"