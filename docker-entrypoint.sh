#!/bin/bash
CUSTOM_XML_FILE=/conf/standalone.xml
if [ -e $CUSTOM_XML_FILE ]; then
     cp $CUSTOM_XML_FILE "/opt/jboss/keycloak/standalone/configuration/standalone.xml"
fi
cat "/opt/jboss/keycloak/standalone/configuration/standalone.xml"

CUSTOM_THEMES=/opt/jboss/keycloak/customthemes

if [ -d "$CUSTOM_THEMES" ]; then
    cp -r ${CUSTOM_THEMES}/* /opt/jboss/keycloak/themes
fi

if [ $KEYCLOAK_USER ] && [ $KEYCLOAK_PASSWORD ]; then
    keycloak/bin/add-user-keycloak.sh --user $KEYCLOAK_USER --password $KEYCLOAK_PASSWORD
fi

exec /opt/jboss/keycloak/bin/standalone.sh $@
exit $?
