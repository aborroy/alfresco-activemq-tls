FROM alfresco/alfresco-activemq:5.17.1-jre17-centos7

COPY tls-conf.sh /opt/activemq/tls-conf.sh

USER root

RUN chmod +x /opt/activemq/tls-conf.sh && \
    chown ${USERNAME}:${GROUPNAME} /opt/activemq/tls-conf.sh

USER ${USERNAME}

RUN sed -i '/^$ACTIVEMQ_HOME\/bin\/activemq*/i /opt/activemq/tls-conf.sh\n' /opt/activemq/init.sh