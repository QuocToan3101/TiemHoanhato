FROM tomcat:9.0-jdk21-temurin

ENV CATALINA_OPTS="-Xms256m -Xmx768m -Dfile.encoding=UTF-8"

ARG WAR_FILE=build/libs/flowerstore.war

COPY ${WAR_FILE} /usr/local/tomcat/webapps/flowerstore.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
