# Status: Development
## TODO:

  3. Restore building of extras in container

  4. Write up how this was developed

  5. Create auto build in docker hub

  6. Add to extension section

  7. Add contributing section

  8. Add credit for 1ambda


docker-kafka-connect
============

Dockerized
[Apache Kafka Connect](http://kafka.apache.org/documentation.html#connect)
(distributed mode) , with additional dependencies added to allow using
the hdfs connector from Confluent

## Why

The docker image from confluent does not work reliably, at least for
me. It mysteriously just falls over without error messages in my
testing.

## What they don't tell you about Kafka Connect

Kafka Connect is pretty well documented, and Confluent have done a good job of producing software that puts a lot of meat on the bones.

Unfortunately, the Confluent docs are far from comprehensive, or even accurate. In addition there's something very, very important they don't tell you:
Out of the box, you can't mix schemaful and schemaless formats.

If you want to output data in a schemaful format (avro, parquet), you need to put data into kafka in one of two schemaful formats: avro, or the special "wrapperised" json format of `{"schema": {...schema obj...}, "payload": {...payload obj}}`. The latter format also doesn't support avro records, so you really only have one and half formats available.

Out of the box, if you want to send arbitrary (but completely uniform) JSON into kafka, you have to write out again as lines of json objects.

## What this image gives you

This images gives you three things:
1. A nicely working Confluent-enhanced kafka connect, demonstrating json to json, and avro to avro functionality
2. Plain kafka connect
3. My own JsonAvro converter class, which allows you to smoothly transition from a JSON-based workflow to a schemaful workflow. (Pending)

## The secret sauce
Dependencies have been added to the POM file in the order they are
needed by execution. This prevents the various dependency jars from
shadowing each others classes. 

## Supported Tags

- **latest** `1.1.0` (2.11) [(1.1.0/Dockerfile)](blob/master/1.1.0/Dockerfile)

## Testing

Required dependencies:
* docker-compose
* avro-tools
* bash
* curl
```
bash tests/test.sh 1.1.0
```

## Quick Start 

### with Docker Compose
[See docker-compose.yml](blob/master/1.1.0/docker-compose.yml)

## Environment Variables

Pass env variables starting with `CONNECT_` to configure `connect-distributed.properties`.  
For example, If you want to set `offset.flush.interval.ms=15000`, use `CONNECT_OFFSET_FLUSH_INTERVAL_MS=15000`

- (**required**) `CONNECT_BOOTSTRAP_SERVERS`
- (*recommended*): `CONNECT_GROUP_ID` (default value: `connect-cluster`) 
- (*recommended*) `CONNECT_REST_ADVERTISED_HOST_NAME`
- (*recommended*) `CONNECT_REST_ADVERTISED_PORT`

Other connect configuration fields are optional. (see also [Kafka Connect Configs](http://kafka.apache.org/documentation.html#connectconfigs))

## How To Extend This Image

Fork the repository, and add additional depedencies to
`pom.xml`. These will be compiled into an uberjar placed on the classpath

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
