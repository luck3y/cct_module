#!/bin/sh
# Configure module
set -e


SCRIPT_DIR=$(dirname $0)
ARTIFACTS_DIR=${SCRIPT_DIR}/artifacts

chown -R jboss:root $ARTIFACTS_DIR
chmod -R ug+rwX $ARTIFACTS_DIR
# compat with prev mvn
mkdir -p ${ARTIFACTS_DIR}/opt/jboss/container/maven/35/
touch ${ARTIFACTS_DIR}/opt/jboss/container/maven/35/scl-enable-maven
chmod ug+x ${ARTIFACTS_DIR}/opt/jboss/container/maven/35/scl-enable-maven

mkdir -p /opt/rh/rh-maven35/
touch /opt/rh/rh-maven35/enable
chmod +x /opt/rh/rh-maven35/enable

pushd ${ARTIFACTS_DIR}
cp -pr * /
popd

# maven pulls in jdk8, so we need to remove them if another jdk is the default
if ! $(ls -la /etc/alternatives/java |grep -q "java-1\.8\.0"); then
    if [ -n "$(rpm -q java-1.8.0-openjdk-devel |grep java-1.8.0-openjdk-devel)" ]; then
        rpm -e --nodeps java-1.8.0-openjdk-devel
    fi

    if [ -n "$(rpm -q java-1.8.0-openjdk-headless |grep java-1.8.0-openjdk-headless)" ]; then
        rpm -e --nodeps java-1.8.0-openjdk-headless
    fi

    if [ -n "$(rpm -q java-1.8.0-openjdk |grep java-1.8.0-openjdk)" ]; then
        rpm -e --nodeps java-1.8.0-openjdk
    fi
fi
