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

# Initialize Kubernetes control plane
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# Configure kubectl for the current user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install a network plugin (Calico in this example)
kubectl apply -f https://docs.projectcalico.org/v3.19/manifests/calico.yaml

# Display cluster information and join command for worker nodes
echo "Kubernetes control plane successfully initialized!"
echo "To join worker nodes to this cluster, run the following command:"
sudo kubeadm token create --print-join-command
