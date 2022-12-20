# Welcome to Alfresco ActiveMQ TLS Docker Image

## Introduction

This repository contains an extension to the original Dockerfile used to create the Alfresco ActiveMQ image available in [https://github.com/Alfresco/alfresco-docker-activemq](https://github.com/Alfresco/alfresco-docker-activemq) with TLS support.

## Keystore

This project includes a sample [keystore](keystore) folder including a sample server `broker.ks` keystore and a sample client `client-truststore.jks` truststore. These keystores are protected with password `password`.

To generate these keystores Java **keytool** program can be used. Choose `activemq` or the service name for the CN of the server certificate.

Create the server certificate `activemq`

```bash
keytool -genkey -alias broker -keyalg RSA -keystore broker.ks
```

Create the client certificate (to connect with the ActiveMQ service) and package it in a Java truststore.

```bash
keytool -export -alias broker -keystore broker.ks -file broker_cert
keytool -genkey -alias client -keyalg RSA -keystore client-truststore.jks
```

## Building

Building the Docker Image locally with tag name `activemq-tls` can be done using regular Docker command.

```
docker build . -t activemq-tls
```

## Running

Following Container paths are expected:

* `/opt/activemq/broker.ks` - activemq server certificate (keystore)
* `/opt/activemq/client-truststore.jks` - activemq client certificate (truststore)

Running `activemq` container with local keystores can executed using following command:

```bash
docker run \
-v $(pwd)/keystore/broker.ks:/opt/activemq/broker.ks \
-v $(pwd)/keystore/client-truststore.jks:/opt/activemq/client-truststore.jks \
activemq-tls
```

## Alfresco services configuration

When using this ActiveMQ TLS container in Alfresco Docker Compose stacks, apply following configuration to each client service to add `client-truststore.jks` truststore:

```
  service:
    image: ...
    environment:
      JAVA_OPTS: "
          -Djavax.net.ssl.trustStore=/opt/client-truststore.jks 
          -Djavax.net.ssl.trustStorePassword=password
          -Djdk.tls.client.protocols=TLSv1.2
          "      
    volumes:
      - ./client-truststore.jks:/opt/client-truststore.jks
```

You may specify TLS version (as the TLSv1.2 in the example above) using the `jdk.tls.client.protocol` environment variable.