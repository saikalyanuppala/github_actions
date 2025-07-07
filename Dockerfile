# ---- Stage 1: Build the application ----
FROM eclipse-temurin:21-jdk AS build

WORKDIR /app

# Copy Gradle wrapper and build files
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# Grant execute permission to gradlew
RUN chmod +x ./gradlew

# Copy the full project and build
COPY . .

# Build Spring Boot jar
RUN ./gradlew clean bootJar

# ---- Stage 2: Run the application ----
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy built jar
COPY --from=build /app/build/libs/*.jar app.jar

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
