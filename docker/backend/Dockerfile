# FROM docker.io/openjdk:21-jdk 
FROM alpine/java:21-jre

LABEL authors="Heinz Lätsch"

# WORKDIR ../../

VOLUME /tmp

VOLUME /data

EXPOSE 8088

ARG JAR_FILE="anmeldetool-server/target/anmeldetool-0.0.4-SNAPSHOT.jar"

COPY ${JAR_FILE} /app.jar

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-Dspring.profiles.active=","-jar","/app.jar"]
