FROM anapsix/alpine-java:jdk8

MAINTAINER Marcin Tustin <marcin@fwd.engineering>

# Install kafka

ENV SCALA_VERSION="2.11" \
    KAFKA_VERSION="1.1.0"
ENV KAFKA_HOME=/opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}

ARG KAFKA_DIST=kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ARG KAFKA_DIST_TGZ=${KAFKA_DIST}.tgz
ARG KAFKA_DIST_ASC=${KAFKA_DIST}.tgz.asc
ARG MAVEN_VERSION=3.5.3
ARG MAVEN_TAR=apache-maven-${MAVEN_VERSION}-bin.tar.gz
ARG MAVEN_DIR=apache-maven-${MAVEN_VERSION}

COPY pom.xml /

RUN set -x && \
    apk add --no-cache unzip curl ca-certificates gnupg jq && \
    eval $(gpg-agent --daemon) && \
    MIRROR=`curl -sSL https://www.apache.org/dyn/closer.cgi\?as_json\=1 | jq -r '.preferred'` && \
    curl -sSLO "${MIRROR}kafka/${KAFKA_VERSION}/${KAFKA_DIST_TGZ}" && \
    curl -sSLO https://dist.apache.org/repos/dist/release/kafka/${KAFKA_VERSION}/${KAFKA_DIST_ASC} && \
    curl -sSLO "${MIRROR}/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_TAR}" && \
    tar xf ${MAVEN_TAR} && \
    curl -sSL  https://kafka.apache.org/KEYS | gpg -q --import - && \
    gpg -q --verify ${KAFKA_DIST_ASC} && \
    mkdir -p /opt && \
    tar xfz ${KAFKA_DIST_TGZ} -C /opt && \
    rm ${KAFKA_DIST_TGZ} && \
#    ${MAVEN_DIR}/bin/mvn package && \
    mkdir -p ${KAFKA_HOME}/extra && \
#    mv target/kafka-connect-plus-1.0.0.jar ${KAFKA_HOME}/extra/ && \
#    rm -rf target/ pom.xml && \
    rm -rf ${MAVEN_DIR} ${MAVEN_TAR} && \
    apk del unzip curl ca-certificates gnupg

# Development only - should be compiled inside the container (no orchestration to build outside)
COPY target/kafka-connect-plus-1.0.0.jar ${KAFKA_HOME}/extra/

# Set env

ENV PATH=$PATH:/${KAFKA_HOME}/bin \
    CONNECT_CFG=${KAFKA_HOME}/config/connect-distributed.properties \
    CONNECT_BIN=${KAFKA_HOME}/bin/connect-distributed.sh

ENV JMX_PORT=9999 \
    CONNECT_PORT=8083

EXPOSE ${JMX_PORT}
EXPOSE ${CONNECT_PORT}

# Run

WORKDIR $KAFKA_HOME
COPY start-connect.sh $KAFKA_HOME/start-connect.sh
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["./start-connect.sh"]
