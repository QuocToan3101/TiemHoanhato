#!/bin/sh

APP_HOME=$(cd "$(dirname "$0")" && pwd)
CLASSPATH="$APP_HOME/gradle/wrapper/*"

if [ -n "$JAVA_HOME" ] && [ -x "$JAVA_HOME/bin/java" ]; then
	JAVA_CMD="$JAVA_HOME/bin/java"
else
	JAVA_CMD="java"
fi

exec "$JAVA_CMD" -Dorg.gradle.appname=gradlew -classpath "$CLASSPATH" org.gradle.wrapper.GradleWrapperMain "$@"
