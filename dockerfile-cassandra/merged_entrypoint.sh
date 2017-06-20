#!/bin/bash
set -e

#### EUREKA ###

source /eureka_utils.sh

if [ $(whoami) = 'root' ]; then
  # Interval between checks if the process is still alive.
  declare -i interval=CHECK_DEPENDENCIES_INTERVAL
  # Delay between posting the SIGTERM signal and destroying the process by SIGKILL.
  declare -i delay=CHECK_KILL_DELAY

  #### Continuous Checks ####

  if [ -n "${FAILED_WHEN}" ]; then
    declare READINESS=true
  else
    declare READINESS="null"
  fi

  if [ -n "${READY_WHEN}" ]; then
    declare ready=false
    desable_ping
  else
    declare ready=$READINESS
  fi

  cmdpid=$BASHPID;
  setup_local_containers ;
  initial_check $cmdpid ;
  (infinite_setup_check $cmdpid) &
  infinite_monitor $cmdpid
fi

### CASSANDRA ###

# first arg is `-f` or `--some-option`
if [ "${1:0:1}" = '-' ]; then
	set -- cassandra -f "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'cassandra' -a "$(id -u)" = '0' ]; then
	chown -R cassandra /var/lib/cassandra /var/log/cassandra "$CASSANDRA_CONFIG"
  exec gosu cassandra "$BASH_SOURCE" "$@" 2>&1
fi

if [ "$1" = 'cassandra' ]; then
	: ${CASSANDRA_RPC_ADDRESS='0.0.0.0'}

	: ${CASSANDRA_LISTEN_ADDRESS='auto'}
	if [ "$CASSANDRA_LISTEN_ADDRESS" = 'auto' ]; then
		CASSANDRA_LISTEN_ADDRESS="$(hostname --ip-address)"
	fi

	: ${CASSANDRA_BROADCAST_ADDRESS="$CASSANDRA_LISTEN_ADDRESS"}

	if [ "$CASSANDRA_BROADCAST_ADDRESS" = 'auto' ]; then
		CASSANDRA_BROADCAST_ADDRESS="$(hostname --ip-address)"
	fi
	: ${CASSANDRA_BROADCAST_RPC_ADDRESS:=$CASSANDRA_BROADCAST_ADDRESS}

	if [ -n "${CASSANDRA_NAME:+1}" ]; then
		: ${CASSANDRA_SEEDS:="cassandra"}
	fi
	: ${CASSANDRA_SEEDS:="$CASSANDRA_BROADCAST_ADDRESS"}

	sed -ri 's/(- seeds:).*/\1 "'"$CASSANDRA_SEEDS"'"/' "$CASSANDRA_CONFIG/cassandra.yaml"

	for yaml in \
		broadcast_address \
		broadcast_rpc_address \
		cluster_name \
		endpoint_snitch \
		listen_address \
		num_tokens \
		rpc_address \
		start_rpc \
	; do
		var="CASSANDRA_${yaml^^}"
		val="${!var}"
		if [ "$val" ]; then
			sed -ri 's/^(# )?('"$yaml"':).*/\2 '"$val"'/' "$CASSANDRA_CONFIG/cassandra.yaml"
		fi
	done

	for rackdc in dc rack; do
		var="CASSANDRA_${rackdc^^}"
		val="${!var}"
		if [ "$val" ]; then
			sed -ri 's/^('"$rackdc"'=).*/\1 '"$val"'/' "$CASSANDRA_CONFIG/cassandra-rackdc.properties"
		fi
	done
fi

exec "$@" 2>&1