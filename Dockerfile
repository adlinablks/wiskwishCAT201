# Stage 1: Build the project
FROM maven:3.8.5-openjdk-17 AS build
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Run it in Tomcat
# We use a specific Tomcat version compatible with Java 17
FROM tomcat:9.0.86-jdk17-temurin

# 1. Clean up default Tomcat apps (so your site is the only one)
RUN rm -rf /usr/local/tomcat/webapps/*

# 2. Copy your WAR file to the "ROOT" folder
# Renaming it to ROOT.war makes it load at your main website URL
COPY --from=build /target/*.war /usr/local/tomcat/webapps/ROOT.war

# 3. Open the port (Tomcat uses 8080 by default)
EXPOSE 8080

# 4. Start Tomcat
CMD ["catalina.sh", "run"]