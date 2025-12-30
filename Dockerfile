# Stage 1: Build the project
FROM maven:3.8.5-openjdk-17 AS build
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Run it in Tomcat 10 (Compatible with Jakarta EE)
# FIX: Switched from Tomcat 9 to Tomcat 10.1 to support 'jakarta.servlet'
FROM tomcat:10.1-jdk17-temurin

# 1. Clean up default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# 2. Copy your WAR file to ROOT
COPY --from=build /target/*.war /usr/local/tomcat/webapps/ROOT.war

# 3. Open port
EXPOSE 8080

# 4. Start
CMD ["catalina.sh", "run"]