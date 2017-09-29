#!/bin/bash
CUSTOM_XML_FILE=/conf/standalone.xml
if [ -e $CUSTOM_XML_FILE ]; then
     cp $CUSTOM_XML_FILE "/opt/jboss/keycloak/standalone/configuration/standalone.xml"
fi
echo -e "-------------------- JBoss config ---------------------------"
cat "/opt/jboss/keycloak/standalone/configuration/standalone.xml"
echo -e "\n"

CUSTOM_THEMES=/opt/jboss/keycloak/customthemes

if [ -d "$CUSTOM_THEMES" ]; then
    cp -r ${CUSTOM_THEMES}/* /opt/jboss/keycloak/themes
fi

if [ -n "$EXPORT_FILE" ]; then
    printf "export data to %s ...\n" "$EXPORT_FILE" 
    exec /opt/jboss/keycloak/bin/standalone.sh -Dkeycloak.migration.action=export -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.file=$EXPORT_FILE
fi

if [ -n "$IMPORT_FILE" ] && [ -e $IMPORT_FILE ]; then
    printf "import data to %s-used ...\n" "$IMPORT_FILE" 
    mv $IMPORT_FILE ${IMPORT_FILE}-used
    exec /opt/jboss/keycloak/bin/standalone.sh -Dkeycloak.migration.action=import -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.file=${IMPORT_FILE}-used
fi

if [ $KEYCLOAK_USER ] && [ $KEYCLOAK_PASSWORD ]; then
    keycloak/bin/add-user-keycloak.sh --user $KEYCLOAK_USER --password $KEYCLOAK_PASSWORD
fi

exec /opt/jboss/keycloak/bin/standalone.sh $@
exit $?
