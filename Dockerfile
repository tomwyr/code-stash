# FROM eclipse-temurin:17-jdk-alpine
# WORKDIR /app
# COPY ./build/libs/late-checker-all.jar /app/late-checker.jar
# CMD ["java", "-server", "-Xmx3g", "-XX:+UseG1GC", "-XX:MaxGCPauseMillis=100", "-jar", "/app/late-checker.jar"]

FROM gradle:7.3.0-jdk17 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle shadowJar --no-daemon

FROM eclipse-temurin:17-jdk-alpine
EXPOSE 8080:8080
RUN mkdir /app
COPY --from=build /home/gradle/src/build/libs/*.jar /app/late-checker.jar
ENTRYPOINT ["java","-jar","/app/late-checker.jar"]
