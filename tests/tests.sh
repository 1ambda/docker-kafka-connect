#!bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${DIR}/../$1"
docker-compose up -d

kafka_broker_port=9092
kafka_broker_hostname=localhost
kafka_broker_container=kafka
kafka_broker=${kafka_broker_hostname}:${kafka_broker_port}
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
        "rotate.interval.ms": "3000",
        "format.class": "io.confluent.connect.hdfs.avro.AvroFormat",
        "value.converter": "io.confluent.connect.avro.AvroConverter",
        "value.converter.schemas.enable": true,
        "value.converter.schema.registry.url": "http://schema-registry:8081"
    }
}'
# expand embeded variable by replacing double quotes with placeholder and evaluating
antiquoted_connector_config=$(eval echo ${connector_config//\"/${antiquote}})
# replace placeholder with original doublequotes to give original string with expansion
expanded_connector_config=${antiquoted_connector_config//${antiquote}/\"}

# put schema into schema registry
## wait for schema registry to be available
echo '# Waiting for schema registry to be available'
until curl -s -X GET http://localhost:8081/subjects || (( schema_count++ >= 5 )); do sleep 4; done
## put schema, escaping double quotes so that it is embedded as a string within the json
echo '# Putting schema'
curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
    --data "{\"schema\": \"${avsc_escaped//[$'\r\n']}\"}" \
     "http://localhost:8081/subjects/${test_topic}-value/versions"

# put data into kafka
echo '# Put test data into kafka'
## put test data
docker-compose exec -T schema-registry kafka-avro-console-producer --property value.schema="${avsc}" \
       --broker-list "${kafka_broker_container}:${kafka_broker_port}" --topic "${test_topic}" < ${DIR}/test_input.jsonlines



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

echo '# Sleeping to allow output to happen'
docker-compose exec hdfs /usr/local/hadoop/bin/hdfs dfs -ls -R /topics
sleep 5
docker-compose stop connect
# output contents of HDFS
if ! docker-compose exec hdfs /usr/local/hadoop/bin/hdfs dfs -ls -R /topics | grep -E "/topics/${test_topic}/partition=0/${test_topic}.{24}.avro"; then
    echo "Avro not generated"
    exit 1
fi

rm ${test_topic}*.avro
docker-compose exec hdfs /usr/local/hadoop/bin/hdfs dfs -get "/topics/${test_topic}/partition=0/${test_topic}*.avro" /mnt/pwd
# TODO - dockerize this?
avrofiles=($(ls ${test_topic}*.avro))
extracted_avsc=$( avro-tools getschema ${avrofiles[0]} | jq --sort-keys 'del(.["connect.version"])|del(.["connect.name"])' )
normalised_avsc=$( echo "${avsc}" | jq --sort-keys '.' )

if [[ "${normalised_avsc}" == "${extracted_avsc}" ]] ; then
    echo "Succesfully wrote avro with same schema as input" ;
    exit 0 ;
else
    exit 1 ;
fi
