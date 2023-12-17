FROM gradle:7.3.0-jdk17 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle shadowJar --no-daemon

FROM eclipse-temurin:17-jdk-alpine
EXPOSE 8080:8080
RUN mkdir /app
COPY /etc/secrets/config.yaml /home/gradle/src/jvmMain/resources/config.yaml
COPY --from=build /home/gradle/src/build/libs/*.jar /app/late-checker.jar
ENTRYPOINT ["java","-jar","/app/late-checker.jar"]
