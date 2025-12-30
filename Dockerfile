# Stage 1: Build
FROM maven:3.8.5-openjdk-17 AS build
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Run
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

# FIX 1: Look for any file ending in .war (instead of .jar)
# FIX 2: Rename it to app.war
COPY --from=build /target/*.war /app/app.war

EXPOSE 8080
# FIX 3: Run the .war file
ENTRYPOINT ["java", "-jar", "/app/app.war"]