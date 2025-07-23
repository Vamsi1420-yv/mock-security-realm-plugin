# ---- Stage 1: Use Maven with JDK 11 (or your required version) ----
FROM maven:3.9.6-eclipse-temurin-11 AS builder

WORKDIR /app

# Copy the project files
COPY . .

# Force download of the Jenkins HPI plugin
# Then build using it
RUN mvn -B clean install -DskipTests --no-transfer-progress

# ---- Stage 2: Output Plugin Only ----
FROM eclipse-temurin:11-jre
WORKDIR /plugin

COPY --from=builder /app/target/*.hpi .

CMD ["ls", "-lh", "."]
