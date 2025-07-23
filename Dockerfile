# --- Build Stage ---
FROM maven:3.9.6-eclipse-temurin-11 AS builder

# Set work directory
WORKDIR /app

# Copy pom first to leverage Docker layer caching
COPY pom.xml .

# Pre-download dependencies to speed up subsequent builds
RUN mvn -B dependency:go-offline

# Copy the rest of the project
COPY . .

# Build plugin (this includes hpi packaging)
RUN mvn clean install -DskipTests

# --- Final Runtime Image ---
FROM eclipse-temurin:11-jre

WORKDIR /plugin

# Copy the built plugin from builder
COPY --from=builder /app/target/*.hpi ./plugin.hpi

# Show the plugin file when container runs
CMD ["ls", "-lh", "."]
