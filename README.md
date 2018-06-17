# Status: Development
## TODO:
  1. Currently "everything works" up to this point:

```
connect_1          | [2018-06-17 20:34:21,196] INFO Started recovery for topic partition avro-test-0 (io.confluent.connect.hdfs.TopicPartitionWriter:252)
connect_1          | [2018-06-17 20:34:21,227] INFO Finished recovery for topic partition avro-test-0 (io.confluent.connect.hdfs.TopicPartitionWriter:267)
connect_1          | [2018-06-17 20:34:21,234] INFO Starting commit and rotation for topic partition avro-test-0 with start offsets {} and end offsets {} (io.confluent.connect.hdfs.TopicPartitionWriter:368)
connect_1          | [2018-06-17 20:34:21,304] INFO Successfully acquired lease for hdfs://hdfs:9000/logs/avro-test/0/log (io.confluent.connect.hdfs.wal.FSWAL:75)
connect_1          | [2018-06-17 20:34:21,685] INFO Opening record writer for: hdfs://hdfs:9000/topics//+tmp/avro-test/partition=0/581873cc-6484-4398-9a6a-9a6dbb014941_tmp.avro (io.confluent.connect.hdfs.avro.AvroRecordWriterProvider:65)
connect_1          | [2018-06-17 20:34:21,727] INFO Opening record writer for: hdfs://hdfs:9000/topics//+tmp/avro-test/partition=0/581873cc-6484-4398-9a6a-9a6dbb014941_tmp.avro (io.confluent.connect.hdfs.avro.AvroRecordWriterProvider:65)
connect_1          | [2018-06-17 20:34:21,736] ERROR WorkerSinkTask{id=hdfs-sink-connector-0} Task threw an uncaught and unrecoverable exception. Task is being killed and will not recover until manually restarted. (org.apache.kafka.connect.runtime.WorkerSinkTask:544)
connect_1          | org.apache.avro.AvroRuntimeException: already open
connect_1          | 	at org.apache.avro.file.DataFileWriter.assertNotOpen(DataFileWriter.java:85)
connect_1          | 	at org.apache.avro.file.DataFileWriter.setCodec(DataFileWriter.java:93)
connect_1          | 	at io.confluent.connect.hdfs.avro.AvroRecordWriterProvider$1.write(AvroRecordWriterProvider.java:69)
connect_1          | 	at io.confluent.connect.hdfs.TopicPartitionWriter.writeRecord(TopicPartitionWriter.java:643)
connect_1          | 	at io.confluent.connect.hdfs.TopicPartitionWriter.write(TopicPartitionWriter.java:379)
connect_1          | 	at io.confluent.connect.hdfs.DataWriter.write(DataWriter.java:374)
connect_1          | 	at io.confluent.connect.hdfs.HdfsSinkTask.put(HdfsSinkTask.java:109)
connect_1          | 	at org.apache.kafka.connect.runtime.WorkerSinkTask.deliverMessages(WorkerSinkTask.java:524)
connect_1          | 	at org.apache.kafka.connect.runtime.WorkerSinkTask.poll(WorkerSinkTask.java:302)
connect_1          | 	at org.apache.kafka.connect.runtime.WorkerSinkTask.iteration(WorkerSinkTask.java:205)
connect_1          | 	at org.apache.kafka.connect.runtime.WorkerSinkTask.execute(WorkerSinkTask.java:173)
connect_1          | 	at org.apache.kafka.connect.runtime.WorkerTask.doRun(WorkerTask.java:170)
connect_1          | 	at org.apache.kafka.connect.runtime.WorkerTask.run(WorkerTask.java:214)
connect_1          | 	at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)
connect_1          | 	at java.util.concurrent.FutureTask.run(FutureTask.java:266)
connect_1          | 	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)
connect_1          | 	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
connect_1          | 	at java.lang.Thread.run(Thread.java:745)
connect_1          | [2018-06-17 20:34:21,747] WARN DataStreamer Exception (org.apache.hadoop.hdfs.DFSClient:557)
connect_1          | org.apache.hadoop.ipc.RemoteException(org.apache.hadoop.hdfs.server.namenode.LeaseExpiredException): No lease on /topics/+tmp/avro-test/partition=0/581873cc-6484-4398-9a6a-9a6dbb014941_tmp.avro (inode 16428): File does not exist. [Lease.  Holder: DFSClient_NONMAPREDUCE_-552753301_46, pendingcreates: 2]
connect_1          | 	at org.apache.hadoop.hdfs.server.namenode.FSNamesystem.checkLease(FSNamesystem.java:3386)
connect_1          | 	at org.apache.hadoop.hdfs.server.namenode.FSNamesystem.analyzeFileState(FSNamesystem.java:3185)
connect_1          | 	at org.apache.hadoop.hdfs.server.namenode.FSNamesystem.getAdditionalBlock(FSNamesystem.java:3032)
connect_1          | 	at org.apache.hadoop.hdfs.server.namenode.NameNodeRpcServer.addBlock(NameNodeRpcServer.java:722)
connect_1          | 	at org.apache.hadoop.hdfs.protocolPB.ClientNamenodeProtocolServerSideTranslatorPB.addBlock(ClientNamenodeProtocolServerSideTranslatorPB.java:492)
connect_1          | 	at org.apache.hadoop.hdfs.protocol.proto.ClientNamenodeProtocolProtos$ClientNamenodeProtocol$2.callBlockingMethod(ClientNamenodeProtocolProtos.java)
connect_1          | 	at org.apache.hadoop.ipc.ProtobufRpcEngine$Server$ProtoBufRpcInvoker.call(ProtobufRpcEngine.java:616)
connect_1          | 	at org.apache.hadoop.ipc.RPC$Server.call(RPC.java:969)
connect_1          | 	at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2049)
connect_1          | 	at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2045)
connect_1          | 	at java.security.AccessController.doPrivileged(Native Method)
connect_1          | 	at javax.security.auth.Subject.doAs(Subject.java:415)
connect_1          | 	at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1657)
connect_1          | 	at org.apache.hadoop.ipc.Server$Handler.run(Server.java:2043)
connect_1          | 
connect_1          | 	at org.apache.hadoop.ipc.Client.call(Client.java:1475)
connect_1          | 	at org.apache.hadoop.ipc.Client.call(Client.java:1412)
connect_1          | 	at org.apache.hadoop.ipc.ProtobufRpcEngine$Invoker.invoke(ProtobufRpcEngine.java:229)
connect_1          | 	at com.sun.proxy.$Proxy53.addBlock(Unknown Source)
connect_1          | 	at org.apache.hadoop.hdfs.protocolPB.ClientNamenodeProtocolTranslatorPB.addBlock(ClientNamenodeProtocolTranslatorPB.java:418)
connect_1          | 	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
connect_1          | 	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
connect_1          | 	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
connect_1          | 	at java.lang.reflect.Method.invoke(Method.java:498)
connect_1          | 	at org.apache.hadoop.io.retry.RetryInvocationHandler.invokeMethod(RetryInvocationHandler.java:191)
connect_1          | 	at org.apache.hadoop.io.retry.RetryInvocationHandler.invoke(RetryInvocationHandler.java:102)
connect_1          | 	at com.sun.proxy.$Proxy54.addBlock(Unknown Source)
connect_1          | 	at org.apache.hadoop.hdfs.DFSOutputStream$DataStreamer.locateFollowingBlock(DFSOutputStream.java:1455)
connect_1          | 	at org.apache.hadoop.hdfs.DFSOutputStream$DataStreamer.nextBlockOutputStream(DFSOutputStream.java:1251)
connect_1          | 	at org.apache.hadoop.hdfs.DFSOutputStream$DataStreamer.run(DFSOutputStream.java:448)
connect_1          | [2018-06-17 20:34:21,751] ERROR Error discarding temp file hdfs://hdfs:9000/topics//+tmp/avro-test/partition=0/581873cc-6484-4398-9a6a-9a6dbb014941_tmp.avro for avro-test-0 partition=0 when closing TopicPartitionWriter: (io.confluent.connect.hdfs.TopicPartitionWriter:448)
connect_1          | org.apache.kafka.connect.errors.DataException: org.apache.hadoop.ipc.RemoteException(org.apache.hadoop.hdfs.server.namenode.LeaseExpiredException): No lease on /topics/+tmp/avro-test/partition=0/581873cc-6484-4398-9a6a-9a6dbb014941_tmp.avro (inode 16428): File does not exist. [Lease.  Holder: DFSClient_NONMAPREDUCE_-552753301_46, pendingcreates: 2]
connect_1          | 	at org.apache.hadoop.hdfs.server.namenode.FSNamesystem.checkLease(FSNamesystem.java:3386)
connect_1          | 	at org.apache.hadoop.hdfs.server.namenode.FSNamesystem.analyzeFileState(FSNamesystem.java:3185)
connect_1          | 	at org.apache.hadoop.hdfs.server.namenode.FSNamesystem.getAdditionalBlock(FSNamesystem.java:3032)
connect_1          | 	at org.apache.hadoop.hdfs.server.namenode.NameNodeRpcServer.addBlock(NameNodeRpcServer.java:722)
connect_1          | 	at org.apache.hadoop.hdfs.protocolPB.ClientNamenodeProtocolServerSideTranslatorPB.addBlock(ClientNamenodeProtocolServerSideTranslatorPB.java:492)
connect_1          | 	at org.apache.hadoop.hdfs.protocol.proto.ClientNamenodeProtocolProtos$ClientNamenodeProtocol$2.callBlockingMethod(ClientNamenodeProtocolProtos.java)
connect_1          | 	at org.apache.hadoop.ipc.ProtobufRpcEngine$Server$ProtoBufRpcInvoker.call(ProtobufRpcEngine.java:616)
connect_1          | 	at org.apache.hadoop.ipc.RPC$Server.call(RPC.java:969)
connect_1          | 	at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2049)
connect_1          | 	at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2045)
connect_1          | 	at java.security.AccessController.doPrivileged(Native Method)
connect_1          | 	at javax.security.auth.Subject.doAs(Subject.java:415)
connect_1          | 	at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1657)
connect_1          | 	at org.apache.hadoop.ipc.Server$Handler.run(Server.java:2043)
connect_1          | 
connect_1          | 	at io.confluent.connect.hdfs.avro.AvroRecordWriterProvider$1.close(AvroRecordWriterProvider.java:96)
connect_1          | 	at io.confluent.connect.hdfs.TopicPartitionWriter.closeTempFile(TopicPartitionWriter.java:655)
connect_1          | 	at io.confluent.connect.hdfs.TopicPartitionWriter.close(TopicPartitionWriter.java:444)
connect_1          | 	at io.confluent.connect.hdfs.DataWriter.close(DataWriter.java:458)
connect_1          | 	at io.confluent.connect.hdfs.HdfsSinkTask.close(HdfsSinkTask.java:135)
connect_1          | 	at org.apache.kafka.connect.runtime.WorkerSinkTask.commitOffsets(WorkerSinkTask.java:377)
connect_1          | 	at org.apache.kafka.connect.runtime.WorkerSinkTask.closePartitions(WorkerSinkTask.java:576)
connect_1          | 	at org.apache.kafka.connect.runtime.WorkerSinkTask.execute(WorkerSinkTask.java:177)
connect_1          | 	at org.apache.kafka.connect.runtime.WorkerTask.doRun(WorkerTask.java:170)
connect_1          | 	at org.apache.kafka.connect.runtime.WorkerTask.run(WorkerTask.java:214)
connect_1          | 	at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)
connect_1          | 	at java.util.concurrent.FutureTask.run(FutureTask.java:266)
connect_1          | 	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)
connect_1          | 	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
connect_1          | 	at java.lang.Thread.run(Thread.java:745)
connect_1          | Caused by: org.apache.hadoop.ipc.RemoteException(org.apache.hadoop.hdfs.server.namenode.LeaseExpiredException): No lease on /topics/+tmp/avro-test/partition=0/581873cc-6484-4398-9a6a-9a6dbb014941_tmp.avro (inode 16428): File does not exist. [Lease.  Holder: DFSClient_NONMAPREDUCE_-552753301_46, pendingcreates: 2]
connect_1          | 	at org.apache.hadoop.hdfs.server.namenode.FSNamesystem.checkLease(FSNamesystem.java:3386)
connect_1          | 	at org.apache.hadoop.hdfs.server.namenode.FSNamesystem.analyzeFileState(FSNamesystem.java:3185)
connect_1          | 	at org.apache.hadoop.hdfs.server.namenode.FSNamesystem.getAdditionalBlock(FSNamesystem.java:3032)
connect_1          | 	at org.apache.hadoop.hdfs.server.namenode.NameNodeRpcServer.addBlock(NameNodeRpcServer.java:722)
connect_1          | 	at org.apache.hadoop.hdfs.protocolPB.ClientNamenodeProtocolServerSideTranslatorPB.addBlock(ClientNamenodeProtocolServerSideTranslatorPB.java:492)
connect_1          | 	at org.apache.hadoop.hdfs.protocol.proto.ClientNamenodeProtocolProtos$ClientNamenodeProtocol$2.callBlockingMethod(ClientNamenodeProtocolProtos.java)
connect_1          | 	at org.apache.hadoop.ipc.ProtobufRpcEngine$Server$ProtoBufRpcInvoker.call(ProtobufRpcEngine.java:616)
connect_1          | 	at org.apache.hadoop.ipc.RPC$Server.call(RPC.java:969)
connect_1          | 	at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2049)
connect_1          | 	at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2045)
connect_1          | 	at java.security.AccessController.doPrivileged(Native Method)
connect_1          | 	at javax.security.auth.Subject.doAs(Subject.java:415)
connect_1          | 	at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1657)
connect_1          | 	at org.apache.hadoop.ipc.Server$Handler.run(Server.java:2043)
connect_1          | 
connect_1          | 	at org.apache.hadoop.ipc.Client.call(Client.java:1475)
connect_1          | 	at org.apache.hadoop.ipc.Client.call(Client.java:1412)
connect_1          | 	at org.apache.hadoop.ipc.ProtobufRpcEngine$Invoker.invoke(ProtobufRpcEngine.java:229)
connect_1          | 	at com.sun.proxy.$Proxy53.addBlock(Unknown Source)
connect_1          | 	at org.apache.hadoop.hdfs.protocolPB.ClientNamenodeProtocolTranslatorPB.addBlock(ClientNamenodeProtocolTranslatorPB.java:418)
connect_1          | 	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
connect_1          | 	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
connect_1          | 	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
connect_1          | 	at java.lang.reflect.Method.invoke(Method.java:498)
connect_1          | 	at org.apache.hadoop.io.retry.RetryInvocationHandler.invokeMethod(RetryInvocationHandler.java:191)
connect_1          | 	at org.apache.hadoop.io.retry.RetryInvocationHandler.invoke(RetryInvocationHandler.java:102)
connect_1          | 	at com.sun.proxy.$Proxy54.addBlock(Unknown Source)
connect_1          | 	at org.apache.hadoop.hdfs.DFSOutputStream$DataStreamer.locateFollowingBlock(DFSOutputStream.java:1455)
connect_1          | 	at org.apache.hadoop.hdfs.DFSOutputStream$DataStreamer.nextBlockOutputStream(DFSOutputStream.java:1251)
connect_1          | 	at org.apache.hadoop.hdfs.DFSOutputStream$DataStreamer.run(DFSOutputStream.java:448)
connect_1          | [2018-06-17 20:34:22,209] ERROR WorkerSinkTask{id=hdfs-sink-connector-0} Task threw an uncaught and unrecoverable exception (org.apache.kafka.connect.runtime.WorkerTask:172)
connect_1          | org.apache.kafka.connect.errors.ConnectException: Exiting WorkerSinkTask due to unrecoverable exception.
connect_1          | 	at org.apache.kafka.connect.runtime.WorkerSinkTask.deliverMessages(WorkerSinkTask.java:546)
connect_1          | 	at org.apache.kafka.connect.runtime.WorkerSinkTask.poll(WorkerSinkTask.java:302)
connect_1          | 	at org.apache.kafka.connect.runtime.WorkerSinkTask.iteration(WorkerSinkTask.java:205)
connect_1          | 	at org.apache.kafka.connect.runtime.WorkerSinkTask.execute(WorkerSinkTask.java:173)
connect_1          | 	at org.apache.kafka.connect.runtime.WorkerTask.doRun(WorkerTask.java:170)
connect_1          | 	at org.apache.kafka.connect.runtime.WorkerTask.run(WorkerTask.java:214)
connect_1          | 	at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)
connect_1          | 	at java.util.concurrent.FutureTask.run(FutureTask.java:266)
connect_1          | 	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)
connect_1          | 	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
connect_1          | 	at java.lang.Thread.run(Thread.java:745)
connect_1          | Caused by: org.apache.avro.AvroRuntimeException: already open
connect_1          | 	at org.apache.avro.file.DataFileWriter.assertNotOpen(DataFileWriter.java:85)
connect_1          | 	at org.apache.avro.file.DataFileWriter.setCodec(DataFileWriter.java:93)
connect_1          | 	at io.confluent.connect.hdfs.avro.AvroRecordWriterProvider$1.write(AvroRecordWriterProvider.java:69)
connect_1          | 	at io.confluent.connect.hdfs.TopicPartitionWriter.writeRecord(TopicPartitionWriter.java:643)
connect_1          | 	at io.confluent.connect.hdfs.TopicPartitionWriter.write(TopicPartitionWriter.java:379)
connect_1          | 	at io.confluent.connect.hdfs.DataWriter.write(DataWriter.java:374)
connect_1          | 	at io.confluent.connect.hdfs.HdfsSinkTask.put(HdfsSinkTask.java:109)
connect_1          | 	at org.apache.kafka.connect.runtime.WorkerSinkTask.deliverMessages(WorkerSinkTask.java:524)
connect_1          | 	... 10 more
connect_1          | [2018-06-17 20:34:22,210] ERROR WorkerSinkTask{id=hdfs-sink-connector-0} Task is being killed and will not recover until manually restarted (org.apache.kafka.connect.runtime.WorkerTask:173)
```

  2. Verify that output has desired k/v schema as defined in
  `tests.sh`

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

## The secret sauce
Dependencies have been added to the POM file in the order they are
needed by execution. This prevents the various dependency jars from
shadowing each others classes. 

## Supported Tags

- **latest** `1.1.0` (2.11) [(1.1.0/Dockerfile)](blob/master/1.1.0/Dockerfile)

## Testing

Required dependencies:
* docker-compose
* kafkacat
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
