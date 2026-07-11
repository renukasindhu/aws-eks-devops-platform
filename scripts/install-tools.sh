#!/bin/bash

set -e

echo "Updating System..."
sudo dnf update -y

# Git
echo "Checking Git..."
if ! command -v git &> /dev/null
then
    echo "Installing Git..."
    sudo dnf install git -y
else
    echo "Git already installed."
fi

# Docker
echo "Checking Docker..."
if ! command -v docker &> /dev/null
then
    echo "Installing Docker..."
    sudo dnf install docker -y
else
    echo "Docker already installed."
fi

echo "Starting Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Adding ec2-user to Docker group..."
sudo usermod -aG docker ec2-user

# Java 17
echo "Checking Java..."
if ! command -v java &> /dev/null
then
    echo "Installing Java 17..."
    sudo dnf install java-17-amazon-corretto -y
else
    echo "Java already installed."
fi

# Maven
echo "Checking Maven..."
if ! command -v mvn &> /dev/null
then
    echo "Installing Maven..."
    sudo dnf install maven -y
else
    echo "Maven already installed."
fi

# AWS CLI
echo "Checking AWS CLI..."
if ! command -v aws &> /dev/null
then
    echo "Installing AWS CLI..."
    sudo dnf install unzip -y
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
else
    echo "AWS CLI already installed."
fi

# kubectl
echo "Checking kubectl..."
if ! command -v kubectl &> /dev/null
then
    echo "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
else
    echo "kubectl already installed."
fi

# eksctl
echo "Checking eksctl..."
if ! command -v eksctl &> /dev/null
then
    echo "Installing eksctl..."
    curl --silent --location \
    "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz
    sudo mv eksctl /usr/local/bin
else
    echo "eksctl already installed."
fi

# Helm
echo "Checking Helm..."
if ! command -v helm &> /dev/null
then
    echo "Installing Helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
else
    echo "Helm already installed."
fi

echo ""
echo "Installed Versions"
echo "=================="

echo ""
git --version

echo ""
docker --version

echo ""
java -version

echo ""
mvn -version

echo ""
aws --version

echo ""
kubectl version --client

echo ""
eksctl version

echo ""
helm version

echo ""
echo "All Required Tools Installed Successfully."

echo "Applying Docker group changes..."
# Refresh the current shell so the Docker group changes take effect
# This lets us run Docker commands without using sudo
newgrp docker

