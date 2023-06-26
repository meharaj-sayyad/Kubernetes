#!/bin/bash

# Update the system
sudo apt-get update

# Install necessary packages
sudo apt-get install -y docker.io

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add the ubuntu user to the docker group
sudo usermod -aG docker ubuntu

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Verify the Minikube installation
minikube version
