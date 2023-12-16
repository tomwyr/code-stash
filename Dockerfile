FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY ./build/libs/late-checker-all.jar /app/late-checker.jar
CMD ["java", "-server", "-Xmx3g", "-XX:+UseG1GC", "-XX:MaxGCPauseMillis=100", "-jar", "/app/late-checker.jar"]

