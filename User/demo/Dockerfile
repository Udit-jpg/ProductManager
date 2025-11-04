# Multi-stage Dockerfile for User service
FROM maven:3.9.4-eclipse-temurin-21 AS build
WORKDIR /app

# Copy only necessary files first to leverage Docker cache
COPY pom.xml ./
COPY src ./src

RUN mvn -B -DskipTests package

FROM eclipse-temurin:21-jdk-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar /app/app.jar
EXPOSE 8081
ENTRYPOINT ["java","-jar","/app/app.jar"]
