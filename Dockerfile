# First stage to build the application
FROM maven:3.5.4-jdk-10-slim AS build-env
# ADD ../${BUILD_FOLDER}/pom.xml pom.xml
# ADD ../${BUILD_FOLDER}/src src/
ADD ./pom.xml pom.xml
ADD ./src src/

RUN mvn clean package

# build runtime image
FROM openjdk:10-jre-slim
ARG APP_NAME=my-app

EXPOSE 8080

ENV SQL_USER="YourUserName" \
SQL_PASSWORD="changeme" \
SQL_SERVER="changeme.database.windows.net" \
SQL_DBNAME="mydrivingDB"

# Add the application's jar to the container
COPY --from=build-env target/${APP_NAME}-1.0-SNAPSHOT.jar user-java.jar

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/user-java.jar"]