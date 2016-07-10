FROM anapsix/alpine-java:jdk8

MAINTAINER 1ambda <1amb4a@gmail.com>

# Install required packages

ENV SCALA_VERSION="2.11" \
    KAFKA_VERSION="0.10.0.0"

ARG KAFKA_DIST=kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ARG KAFKA_DIST_TGZ=${KAFKA_DIST}.tgz
ARG MIRROR=http://apache.mirrors.spacedump.net/kafka/${KAFKA_VERSION}

RUN apk add --update unzip wget curl docker jq coreutils

# Install kafka

RUN mkdir -p /opt && \
    wget -q ${MIRROR}/${KAFKA_DIST_TGZ} -O /tmp/${KAFKA_DIST_TGZ} && \
    tar xfz /tmp/${KAFKA_DIST_TGZ} -C /opt && \
    rm /tmp/${KAFKA_DIST_TGZ}

# Set env

ENV KAFKA_HOME=/opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}

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