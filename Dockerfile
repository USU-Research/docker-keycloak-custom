FROM jboss/keycloak-postgres:4.3.0.Final

USER root

ADD docker-entrypoint.sh /opt/jboss/
RUN chmod a+x /opt/jboss/docker-entrypoint.sh

USER jboss
