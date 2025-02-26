#!/bin/bash
set -e

LOG_FILE="/var/log/setup.log"
exec > >(tee -a "$LOG_FILE") 2>&1  # Log output to both console and file

echo "🚀 Starting setup script..."

# Function to check if a package is installed
check_installed() {
    if ! rpm -q "$1" &>/dev/null; then
        echo "❌ $1 is NOT installed. Exiting!"
        exit 1
    else
        echo "✅ $1 is installed."
    fi
}

# Update system packages
echo "🔄 Updating system packages..."
sudo yum update -y

# Install required packages
echo "📦 Installing required packages..."
sudo yum install -y git unzip wget jq
check_installed git
check_installed unzip
check_installed wget
check_installed jq


# Install Jenkins
echo "🔧 Installing Jenkins..."
sudo yum install -y java-17-amazon-corretto
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo yum install -y jenkins
sudo systemctl start jenkins
check_installed jenkins
sudo systemctl enable --now jenkins

# Wait for Jenkins to start
sleep 10
echo "✅ Jenkins installation complete."

# Install Docker
echo "🐳 Installing Docker..."
sudo yum install -y docker
sudo service docker start
sudo usermod -aG docker $USER
sudo usermod -aG docker jenkins
sudo chmod 666 /var/run/docker.sock
sudo systemctl restart docker
sudo systemctl enable --now docker
check_installed docker

# Wait for Docker to start
sleep 10
echo "✅ Docker installation complete."

# Install SonarQube (Docker)
echo "🔍 Deploying SonarQube container..."
sudo docker network create sonarnet
sudo docker run -d --name sonarqube --network sonarnet -p 9000:9000 -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true sonarqube:lts

# Check if SonarQube container is running
if sudo docker ps | grep -q "sonarqube"; then
    echo "✅ SonarQube container started."
else
    echo "❌ SonarQube failed to start!"
    exit 1
fi

# Install Trivy (Vulnerability Scanner)
rpm -ivh https://github.com/aquasecurity/trivy/releases/download/v0.57.1/trivy_0.57.1_Linux-64bit.rpm

# Verify Trivy installation
if command -v trivy &>/dev/null; then
    echo "✅ Trivy installation complete."
else
    echo "❌ Trivy installation failed!"
    exit 1
fi

# Output Jenkins and SonarQube URLs
echo "🔑 Jenkins Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo "🌍 SonarQube URL: http://$(curl -s ifconfig.me):9000"

echo "🎉 Setup completed successfully!"
