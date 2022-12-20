#!/usr/bin/env bash
set -e

sed -i "s/tcp/ssl/g" ${ACTIVEMQ_HOME}/conf/activemq.xml

sed -i "s/\
[[:space:]]\+<\/broker>/\n\
        <sslContext>\n\
          <sslContext keyStore=\"file:\/opt\/activemq\/broker.ks\"\n\
            keyStorePassword=\"password\" trustStore=\"file:\/opt\/activemq\/client-truststore.jks\"\n\
            trustStorePassword=\"password\"\/>\n\
        <\/sslContext>\n\
        <\/broker>/g" ${ACTIVEMQ_HOME}/conf/activemq.xml