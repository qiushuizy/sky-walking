#!/bin/sh

# OS specific support.  $var _must_ be set to either true or false.
cygwin=false
os400=false
darwin=false
case "`uname`" in
CYGWIN*) cygwin=true;;
OS400*) os400=true;;
Darwin*) darwin=true;;
esac

# resolve links - $0 may be a softlink
SW_ALARM_ALARM_SERVER_BIN="$0"

while [ -h "$SW_ALARM_ALARM_SERVER_BIN" ]; do
  ls=`ls -ld "$SW_ALARM_ALARM_SERVER_BIN"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    SW_ALARM_ALARM_SERVER_BIN="$link"
  else
    SW_ALARM_ALARM_SERVER_BIN=`dirname "$SW_ALARM_ALARM_SERVER_BIN"`/"$link"
  fi
done

# Get standard environment variables
SW_ALARM_ALARM_SERVER_BIN_DIR=`dirname "$SW_ALARM_ALARM_SERVER_BIN"`
SW_ALARM_ALARM_PREFIX="${SW_ALARM_ALARM_SERVER_BIN_DIR}/.."
SW_ALARM_ALARM_LOG_DIR="${SW_ALARM_ALARM_SERVER_BIN_DIR}/../logs"
SW_ALARM_ALARM_CFG_DIR="${SW_ALARM_ALARM_SERVER_BIN_DIR}/../config"

if [ ! -d "${SW_ALARM_ALARM_LOG_DIR}" ]; then
    echo "create directory $SW_ALARM_ALARM_LOG_DIR"
    mkdir -p ${SW_ALARM_ALARM_LOG_DIR}
fi

#echo $SW_ALARM_ALARM_SERVER_BIN_DIR
#set java home
if [ "$JAVA_HOME" != "" ]; then
  JAVA="$JAVA_HOME/bin/java"
else
  JAVA=java
fi

CLASSPATH="$SW_ALARM_ALARM_CFG_DIR:$CLASSPATH"

for i in "${SW_ALARM_ALARM_SERVER_BIN_DIR}"/../libs/*.jar
do
    CLASSPATH="$i:$CLASSPATH"
done

echo "CLASSPATH=$CLASSPATH"

JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"

$JAVA ${JAVA_OPTS} -classpath $CLASSPATH com.a.eye.skywalking.alarm.AlarmProcessServer >> ${SW_ALARM_ALARM_LOG_DIR}/sw-alarm-server.log & 2>&1&

