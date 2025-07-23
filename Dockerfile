FROM jenkins/jenkins:lts-jdk17

USER root

# Install dependencies (optional: for CLI tools, git, etc.)
RUN apt-get update && apt-get install -y git unzip && rm -rf /var/lib/apt/lists/*

# Set up plugin directory
COPY target/mock-security-realm.hpi /usr/share/jenkins/ref/plugins/mock-security-realm.hpi

# Change ownership to Jenkins user
RUN chown -R jenkins:jenkins /usr/share/jenkins/ref/plugins

USER jenkins

# Optional: pre-install plugins via install-plugins.sh
# COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
# RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Expose default port
EXPOSE 8080

# Entrypoint is already defined in base image
