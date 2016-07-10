#!/usr/bin/env bash

set -e

if [[ -z "$CONNECT_REST_ADVERTISED_HOST_NAME" ]]; then
  error "EMPTY ENV 'CONNECT_REST_ADVERTISED_HOST_NAME'"; exit 1
fi

if [[ -z "$CONNECT_REST_ADVERTISED_PORT" ]]; then
  error "EMPTY ENV 'CONNECT_REST_ADVERTISED_PORT'"; exit 1
fi

if [[ -z "$CONNECT_BOOTSTRAP_SERVERS" ]]; then
  error "EMPTY ENV 'CONNECT_BOOTSTRAP_SERVERS'"; exit 1
fi

if [[ -z "$CONNECT_GROUP_ID" ]]; then
  warn "EMPTY ENV 'CONNECT_GROUP_ID'. USE DEFAULT VALUE"; unset CONNECT_GROUP_ID
fi

export KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=${CONNECT_REST_ADVERTISED_HOST_NAME} -Dcom.sun.management.jmxremote.rmi.port=9999 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"

echo -e "\n" >> $CONNECT_CFG # Add newline

for VAR in `env`
do
  if [[ $VAR =~ ^CONNECT_ && ! $VAR =~ ^CONNECT_CFG && ! $VAR =~ ^CONNECT_BIN ]]; then
    connect_name=`echo "$VAR" | sed -r "s/CONNECT_(.*)=.*/\1/g" | tr '[:upper:]' '[:lower:]' | tr _ .`
    env_var=`echo "$VAR" | sed -r "s/(.*)=.*/\1/g"`
    if egrep -q "(^|^#)$connect_name=" $CONNECT_CFG; then
        sed -r -i "s@(^|^#)($connect_name)=(.*)@\2=${!env_var}@g" $CONNECT_CFG
    else
        echo "$connect_name=${!env_var}" >> $CONNECT_CFG
    fi
  fi
done

exec "$@"