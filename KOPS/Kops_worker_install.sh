#!/bin/bash

# Update the system
sudo yum update -y

# Install necessary packages
sudo yum install -y wget unzip

# Download and install kops
wget https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops

# Install kubectl
sudo yum install -y kubectl

# Install Docker
sudo yum install -y docker

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Configure cgroup driver for Docker to use systemd
sudo sed -i 's/^ExecStart=\/usr\/bin\/dockerd -H fd:\/\//ExecStart=\/usr\/bin\/dockerd -H fd:\/\/ --containerd=\/run\/containerd\/containerd.sock --exec-opt native.cgroupdriver=systemd/' /usr/lib/systemd/system/docker.service
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker

# Optional: Configure Docker to use the overlay2 storage driver
echo '{"storage-driver": "overlay2"}' | sudo tee /etc/docker/daemon.json
sudo systemctl restart docker

# Optional: Configure Docker to allow insecure registries if needed
# Edit /etc/sysconfig/docker and add the insecure registry address to the OPTIONS line, e.g., OPTIONS='--insecure-registry myregistry.example.com'

# Note: You may need to configure firewall rules and security groups to allow traffic to/from Kubernetes components.

# Verify kops installation
kops version
