# ---------- STAGE 1: Build the JAR ----------
FROM maven:3.9.9-eclipse-temurin-21 AS builder

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# ---------- STAGE 2: Runtime ----------
FROM ubuntu:22.04

# Install Apache2 and Java
RUN apt-get update && \
    apt-get install -y apache2 openjdk-21-jre && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache proxy modules
RUN a2enmod proxy proxy_http

# Configure Apache to proxy requests to Spring Boot
RUN echo '<VirtualHost *:80>\n\
ProxyPreserveHost On\n\
ProxyPass / http://localhost:8080/\n\
ProxyPassReverse / http://localhost:8080/\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 80

CMD java -jar /app/app.jar & apache2ctl -D FOREGROUND
