#!/usr/bin/env sh 

server() {

conf="/etc/nutcracker.yml"

echo -n "
pool:
  listen: ${IP:-0.0.0.0}:${PORT:-8888}
  hash: fnv1a_64
  distribution: ketama
  redis: true
  auto_eject_hosts: ${AUTO_EJECT_HOSTS:-true}
  timeout: ${TIMEOUT:-2000}
  server_retry_timeout: ${SERVER_RETRY_TIMEOUT:-5000}
  server_failure_limit: ${SERVER_FAILURE_LIMIT:-1}
  server_connections: ${SERVER_CONNECTIONS:-40}
  preconnect: ${PRECONNECT:-true}
  servers:
" > $conf

if [ ! -z "$REDIS_SERVERS" ]; then
  for host in ${REDIS_SERVERS:-ssdb:8888:1} ; do
     echo  "  - ${host}" >> $conf
  done
fi

	## Launch
	exec nutcracker -v ${VERBOSE:-11} -c $conf
}

if [ "$1" = 'server' ]; then
	server
else
	exec "$@"
fi
