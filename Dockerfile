# Stage 1: Build the plugin with Jenkins plugin repos
FROM maven:3.9.6-eclipse-temurin-11 AS builder

WORKDIR /app

# Inject Jenkins plugin repos without external settings.xml
RUN mkdir -p /root/.m2 && echo '\
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0">\
  <profiles>\
    <profile>\
      <id>jenkins</id>\
      <repositories>\
        <repository>\
          <id>central</id>\
          <url>https://repo.maven.apache.org/maven2</url>\
        </repository>\
        <repository>\
          <id>jenkins</id>\
          <url>https://repo.jenkins-ci.org/public/</url>\
        </repository>\
        <repository>\
          <id>incrementals</id>\
          <url>https://repo.jenkins-ci.org/incrementals/</url>\
        </repository>\
      </repositories>\
    </profile>\
  </profiles>\
  <activeProfiles>\
    <activeProfile>jenkins</activeProfile>\
  </activeProfiles>\
</settings>' > /root/.m2/settings.xml

COPY . .

RUN mvn -B clean install -DskipTests --no-transfer-progress

# Stage 2: Runtime image (optional if you want to deploy plugin output)
FROM eclipse-temurin:11-jre
WORKDIR /plugin
COPY --from=builder /app/target/*.hpi .
CMD ["ls", "-lh", "."]
