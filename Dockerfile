# syntax = docker/dockerfile:1.2

FROM gradle:7.3.0-jdk17 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN cp ./config.yaml ./src/jvmMain/resources/config.yaml
RUN gradle shadowJar --no-daemon

FROM eclipse-temurin:17-jdk-alpine
EXPOSE 8080:8080
RUN mkdir /app
COPY --from=build /home/gradle/src/build/libs/*.jar /app/late-checker.jar
ENTRYPOINT ["java","-jar","/app/late-checker.jar"]
