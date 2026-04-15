@echo off
setlocal

set "APP_HOME=%~dp0"
set "CLASSPATH=%APP_HOME%gradle\wrapper\*"
set "JAVA_CMD=java"

if defined JAVA_HOME (
	if exist "%JAVA_HOME%\bin\java.exe" set "JAVA_CMD=%JAVA_HOME%\bin\java.exe"
)

"%JAVA_CMD%" -Dorg.gradle.appname=gradlew -classpath "%CLASSPATH%" org.gradle.wrapper.GradleWrapperMain %*
endlocal
