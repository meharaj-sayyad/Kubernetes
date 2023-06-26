#!/bin/bash

# Update the system
sudo yum update -y

# Install necessary packages
sudo yum install -y docker

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add the ec2-user to the docker group
sudo usermod -aG docker ec2-user

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Verify the Minikube installation
minikube version
