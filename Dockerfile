# --- Stage 1: Build the application ---
FROM maven:3.8.8-eclipse-temurin-21-alpine AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# --- Stage 2: Run the application ---
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
# Change this line to copy the WAR file instead of JAR
COPY --from=build /app/target/ExcelToSqlConverter-0.0.1-SNAPSHOT.war app.war
EXPOSE 8080
# Change the entrypoint to use the WAR file
ENTRYPOINT ["java", "-jar", "app.war"]
