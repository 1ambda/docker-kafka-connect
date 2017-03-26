[![Docker Pulls](https://img.shields.io/docker/pulls/1ambda/kafka-connect.svg)](https://hub.docker.com/r/1ambda/kafka-connect/)
[![Docker Stars](https://img.shields.io/docker/stars/1ambda/kafka-connect.svg)](https://hub.docker.com/r/1ambda/kafka-connect/)

docker-kafka-connect
============

Dockerized [Apache Kafka Connect](http://kafka.apache.org/documentation.html#connect) (distributed mode) 

## Supported Tags

- `0.10.0.0` (2.11) [(0.10.0.0/Dockerfile)](https://github.com/1ambda/docker-kafka-connect/blob/master/0.10.0.0/Dockerfile)
- `0.10.1.1` (2.11) [(0.10.1.0/Dockerfile)](https://github.com/1ambda/docker-kafka-connect/blob/master/0.10.1.1/Dockerfile)

## Quick Start 

### with Docker Compose

Write `docker-compose.yml` like and then execute `docker-compose up`

```yaml
version: '2'
services:
  zk:
    image: 31z4/zookeeper:3.4.8

  kafka:
    image: ches/kafka
    links:
      - zk
    environment:
      KAFKA_BROKER_ID: 0
      KAFKA_ADVERTISED_HOST_NAME: kafka
      KAFKA_ADVERTISED_PORT: 9092
      ZOOKEEPER_CONNECTION_STRING: zk:2181
      ZOOKEEPER_CHROOT: /broker-0

  connect:
    image: 1ambda/kafka-connect
    links:
      - kafka
    ports:
      - "8083:8083"
    environment:
      CONNECT_BOOTSTRAP_SERVERS: kafka:9092
      CONNECT_GROUP_ID: connect-cluster-A
```

### with Docker CLI

```shell
$ docker run -d --name zk 31z4/zookeeper:3.4.8

$ docker run -d --name kafka \
    -e KAFKA_BROKER_ID=0 \
    -e KAFKA_ADVERTISED_PORT=9092 \
    -e ZOOKEEPER_CONNECTION_STRING=zk:2181 \ 
    --link zk:zk ches/kafka
    
$ docker run --rm --name connect \
    -p 8083:8083 \
    -e CONNECT_BOOTSTRAP_SERVERS=kafka:9092 \
    -e CONNECT_GROUP_ID=connect-cluster-A \
    --link kafka:kafka 1ambda/kafka-connect
```

## Environment Variables

Pass env variables starting with `CONNECT_` to configure `connect-distributed.properties`.  
For example, If you want to set `offset.flush.interval.ms=15000`, use `CONNECT_OFFSET_FLUSH_INTERVAL_MS=15000`

- (**required**) `CONNECT_BOOTSTRAP_SERVERS`
- (*recommended*): `CONNECT_GROUP_ID` (default value: `connect-cluster`) 
- (*recommended*) `CONNECT_REST_ADVERTISED_HOST_NAME`
- (*recommended*) `CONNECT_REST_ADVERTISED_PORT`

Other connect configuration fields are optional. (see also [Kafka Connect Configs](http://kafka.apache.org/documentation.html#connectconfigs))

## How To Extend This Image

If you want to run additional connectors, add connector JARs to `${KAFKA_HOME}/connectors` in container.

```
FROM 1ambda/kafka-connect:latest

# same as `cp -R connectors/ $KAFKA_HOME/`
# the entrypoint will extends `$CLASSPATH` 
# like `export CLASSPATH=${CLASSPATH}:${KAFKA_HOME}/connectors/*`

COPY connectors $KAFKA_HOME/connectors
```

## Development

- **SCALA_VERSION**: `2.11` 
- **KAFKA_VERSION**: `0.10.0.0`
- **KAFKA_HOME**: `/opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}`
- **CONNECT_CFG**: `${KAFKA_HOME}/config/connect-distributed.properties`
- **CONNECT_BIN**: `${KAFKA_HOME}/bin/connect-distributed.sh`
- **CONNECT_PORT**: `8083` (exposed)
- **JMX_PORT**: `9999` (exposed)
 
# License

Apache 2.0
