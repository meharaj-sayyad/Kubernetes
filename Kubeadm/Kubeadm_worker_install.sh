#!/bin/bash

# Update the system
sudo yum update -y

# Disable swap
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab

# Install Docker
sudo yum install -y docker

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Add Kubernetes repository and install necessary packages
sudo tee /etc/yum.repos.d/kubernetes.repo <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Install kubelet, kubeadm, and kubectl
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

# Enable and start kubelet
sudo systemctl enable kubelet
sudo systemctl start kubelet

# Join the Kubernetes cluster using the join command from the master node
# Replace "<master-node-ip>" and "<token>" with the appropriate values
sudo kubeadm join <master-node-ip>:6443 --token <token> --discovery-token-unsafe-skip-ca-verification
