#!/usr/bin/env bash

TOMCAT_HOME=/opt/tomcat

#
# This is the docker run script that is placed in the $CATALINA_HOME/bin folder to be executed inside a docker container
#

: ${SIGNSERVICE_DATALOCATION:=/opt/signservice}
: ${DEBUG_MODE:=false}

export SIGNSERVICE_DATALOCATION=$SIGNSERVICE_DATALOCATION
export DEBUG_MODE=$DEBUG_MODE

#
# System settings
#
: ${JVM_MAX_HEAP:=1536m}
: ${JVM_START_HEAP:=512m}
: ${DEBUG_PORT:=8000}

export JAVA_OPTS="-XX:MaxPermSize=512m"
export CATALINA_OPTS="\
          -Xmx${JVM_MAX_HEAP}\
          -Xms${JVM_START_HEAP}\
"

#
# Debug
#
export JPDA_ADDRESS=${DEBUG_PORT}
export JPDA_TRANSPORT=dt_socket

if [ $DEBUG_MODE == true ]; then
    echo "Running in debug"
    ${TOMCAT_HOME}/bin/catalina.sh jpda run
else
    echo "Running in normal mode"
    ${TOMCAT_HOME}/bin/catalina.sh run
fi
