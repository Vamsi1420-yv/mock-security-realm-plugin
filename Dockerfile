# -------- Build Stage --------
FROM maven:3.9.6-eclipse-temurin-11 AS builder

# Set working directory inside container
WORKDIR /app

# Copy entire project (pom.xml + source)
COPY . .

# Build Jenkins plugin and skip tests to speed up CI
RUN mvn clean install -DskipTests

# -------- Final Runtime Image --------
FROM eclipse-temurin:11-jre

# Set workdir for final image
WORKDIR /plugin

# Copy the built .hpi file from builder image
COPY --from=builder /app/target/*.hpi ./plugin.hpi

# Default command to verify image content (can be changed in pipeline)
CMD ["ls", "-lh", "."]
