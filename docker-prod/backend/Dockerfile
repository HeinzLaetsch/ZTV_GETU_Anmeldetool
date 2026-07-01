FROM openjdk:11-jdk 

MAINTAINER Heinz Lätsch

# WORKDIR /anmeldetool

VOLUME /tmp

VOLUME /data

EXPOSE 8088

ARG JAR_FILE=./backend/anmeldetool-0.0.1-SNAPSHOT.jar

COPY ${JAR_FILE} /app.jar

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-Dspring.profiles.active=","-jar","/app.jar"]
