[![Docker Pulls](https://img.shields.io/docker/pulls/1ambda/kafka-connect.svg)](https://hub.docker.com/r/1ambda/kafka-connect/)
[![Docker Stars](https://img.shields.io/docker/stars/1ambda/kafka-connect.svg)](https://hub.docker.com/r/1ambda/kafka-connect/)
[![](https://badge.imagelayers.io/1ambda/kafka-connect:latest.svg)](https://imagelayers.io/?images=1ambda/kafka-connect:latest)

docker-kafka-connect
============

Dockerized [Apache Kafka Connect](http://kafka.apache.org/documentation.html#connect) (distributed mode) 

## Supported Tags

- `0.10.0.0` [(0.10.0.0/Dockerfile)](https://github.com/1ambda/docker-kafka-connect/blob/master/0.10.0.0/Dockerfile)

## Usage

### with Docker Compose

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
      CONNECT_REST_ADVERTISED_HOST_NAME: connect
      CONNECT_REST_ADVERTISED_PORT: 8083
      CONNECT_BOOTSTRAP_SERVERS: kafka:9092
```

### with Docker CLI

```shell
$ docker run -d --name zk 31z4/zookeeper:3.4.8

$ docker run -d --name kafka \
    -e KAFKA_BROEKR_ID=0 \
    -e KAFKA_ADVERTISED_PORT=9092 \
    -e ZOOKEEPER_CONNECTION_STRING=zk:2181 \ 
    --link zk:zk ches/kafka
    
$ docker run --rm --name connect \
    -p 8083:8083 \
    -e JMX_PORT=10000 \
    -e CONNECT_REST_ADVERTISED_HOST_NAME=connect \
    -e CONNECT_REST_ADVERTISED_PORT=8083 \
    -e CONNECT_BOOTSTRAP_SERVERS=kafka:9092 \
    -e CONNECT_GROUP_ID=connect-cluster-A \
    --link kafka:kafka 1ambda/kafka-connect
```

## Environment Variables

### Connect

Pass env variables starting with `CONNECT_` to configure `connect-distributed.properties`.  
For example, If you want to set `offset.flush.interval.ms=15000`, use `CONNECT_OFFSET_FLUSH_INTERVAL_MS=15000`

- (**required**) `CONNECT_REST_ADVERTISED_HOST_NAME`
- (**required**) `CONNECT_REST_ADVERTISED_PORT`
- (**required**) `CONNECT_BOOTSTRAP_SERVERS`
- (*recommended*): `CONNECT_GROUP_ID` (default value: `connect-cluster`) 

Other connect configuration fields are optional.  
See also [Kafka Connect Configs](http://kafka.apache.org/documentation.html#connectconfigs).
 
# License

**Apache 2.0**
