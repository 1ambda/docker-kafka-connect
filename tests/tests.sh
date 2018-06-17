#!bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${DIR}/../$1"
docker-compose up -d

kafka_broker=localhost:9092
test_topic=avro-test

avsc='{
  "type": "record",
  "name": "kv_pair",
  "fields": [
    { "name": "key", "type": "string" },
    { "name": "value", "type": "string" }
  ]
}'
avsc_escaped=${avsc//'"'/\\\"}


antiquote=‹
# because of the shell parameter substitution, literal $ signs must be escaped
# schemas: false because conversion happens before transformation - see
# connect/runtime/src/main/java/org/apache/kafka/connect/runtime/WorkerSinkTask.java:462
# (convertMessages)
connector_config='{
    "name": "hdfs-sink-connector",
    "config": {
        "connector.class": "io.confluent.connect.hdfs.HdfsSinkConnector",
        "tasks.max": "1",
        "topics": "${test_topic}",
        "hdfs.url": "hdfs://hdfs:9000",
        "flush.size": "3",
        "rotate.interval.ms": "10",
        "format.class": "io.confluent.connect.hdfs.avro.AvroFormat",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "value.converter.schemas.enable": false,
        "transforms": "HoistToPayload,InsertSchema",
        "transforms.HoistToPayload.type": "org.apache.kafka.connect.transforms.HoistField\$Value",
        "transforms.HoistToPayload.field": "payload",
        "transforms.InsertSchema.type": "org.apache.kafka.connect.transforms.InsertField\$Value",
        "transforms.InsertSchema.static.field": "schema",
        "transforms.InsertSchema.static.value": "${avsc_escaped//[$'\r\n']}"
    }
}'
# expand embeded variable by replacing double quotes with placeholder and evaluating
antiquoted_connector_config=$(eval echo ${connector_config//\"/${antiquote}})
# replace placeholder with original doublequotes to give original string with expansion
expanded_connector_config=${antiquoted_connector_config//${antiquote}/\"}

# put data into kafka
## wait for kafka to be available
# until kafkacat -L -b ${kafka_broker} || (( kafka_count++ >= 5 )); do sleep 2; done
## put test data
docker-compose exec -T kafka kafka-console-producer \
       --broker-list "${kafka_broker}" --topic "${test_topic}" < ${DIR}/test_input.jsonlines

# put schema into schema registry
## wait for schema registry to be available
echo '# Waiting for schema registry to be available'
until curl -s -X GET http://localhost:8081/subjects || (( schema_count++ >= 5 )); do sleep 2; done
## put schema, escaping double quotes so that it is embedded as a string within the json
echo '# Putting schema'
curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
    --data "{\"schema\": \"${avsc_escaped//[$'\r\n']}\"}" \
     "http://localhost:8081/subjects/${test_topic}-value/versions"

# create sink task to write to hdfs
## wait for hdfs to be available
echo '# Waiting for hdfs to be available'
until (curl 'http://localhost:50070/jmx?qry=Hadoop:service=NameNode,name=FSNamesystemState' | \
        jq --exit-status '.beans[0].FSState == "Operational"') || (( hdfs_count++ >= 5 ));
do sleep 5; done

## wait for kafka connect to be available
echo '# Waiting for kafka connect to be available'
until curl -s -X GET http://localhost:8083/connectors || (( put_sink_count++ >= 5 ));
do sleep 2; done

# Worst hack
echo '# Sleeping for 30s to allow HDFS to stabilize'
sleep 30

echo '# Putting connector config '
## put connector config (without embedded newlines, it makes jackson sad
curl -XPOST -H "Content-Type: application/json" --data "${expanded_connector_config//[$'\r\n']}" \
     http://localhost:8083/connectors

# output contents of HDFS
docker-compose exec hdfs /usr/local/hadoop/bin/hdfs dfs -ls -R /topics
