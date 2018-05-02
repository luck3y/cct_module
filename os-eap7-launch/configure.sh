#!/bin/sh
# Openshift EAP launch script and helpers
set -e

SCRIPT_DIR=$(dirname $0)
ADDED_DIR=${SCRIPT_DIR}/added

# Add custom launch script and dependent scripts/libraries/snippets
cp -p ${ADDED_DIR}/openshift-launch.sh ${ADDED_DIR}/openshift-migrate.sh ${JBOSS_HOME}/bin/
mkdir -p ${JBOSS_HOME}/bin/launch
cp -r ${ADDED_DIR}/launch/* ${JBOSS_HOME}/bin/launch
chmod ug+x ${JBOSS_HOME}/bin/openshift-launch.sh ${JBOSS_HOME}/bin/openshift-migrate.sh

# remove the min metaspace
sed -i "s|-XX:MetaspaceSize=96M||" $JBOSS_HOME/bin/standalone.conf

chown -R jboss:root ${JBOSS_HOME}/bin/
chmod -R g+rwX ${JBOSS_HOME}/bin/
