# ---- Stage 1: Build plugin using Maven ----
FROM maven:3.9.6-eclipse-temurin-11 AS builder

WORKDIR /app

# Copy pom.xml first to leverage Docker cache
COPY pom.xml .

# Explicitly resolve hpi packaging support
RUN mvn -B org.apache.maven.plugins:maven-dependency-plugin:3.6.0:get \
  -Dartifact=org.jenkins-ci.tools:maven-hpi-plugin:3.44

# Now copy full source and build
COPY . .

# Build the Jenkins plugin
RUN mvn -B clean install -DskipTests

# ---- Stage 2: Optional minimal image with built plugin only ----
FROM eclipse-temurin:11-jre
WORKDIR /plugin

COPY --from=builder /app/target/*.hpi .

CMD ["ls", "-lh", "."]
