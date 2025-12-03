FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY target/maha-0.0.1-SNAPSHOT.jar  target/maha-0.0.1-SNAPSHOT.jar 
ENTRYPOINT ["java", "-jar", "target/maha-0.0.1-SNAPSHOT.jar "]
EXPOSE 8080
