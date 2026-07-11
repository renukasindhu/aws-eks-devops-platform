# Stage 1 - Build the application
FROM maven:3.9.11-amazoncorretto-17 AS builder

WORKDIR /app

COPY . .

RUN mvn clean package \
    -Dspring.profiles.active=build \
    -DskipTests

# Stage 2 - Runtime Image
FROM amazoncorretto:17-alpine-jdk

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8084

CMD ["java", "-jar", "app.jar"]
