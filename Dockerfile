# -------- Stage 1: Build the application --------
FROM maven:3.9.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy source code
COPY . .

# Build the JAR file
RUN mvn clean package -DskipTests


# -------- Stage 2: Run the application --------
FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

# Copy jar from builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose application port
EXPOSE 80

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
