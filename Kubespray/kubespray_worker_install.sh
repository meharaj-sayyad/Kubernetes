#!/bin/bash

# Update the system
sudo yum update -y

# Install necessary packages
sudo yum install -y epel-release
sudo yum install -y python3 python3-pip

# Install Ansible
sudo pip3 install ansible==2.10.7

# Clone Kubespray repository
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray

# Install dependencies
sudo pip3 install -r requirements.txt

# Copy the inventory template
cp -rfp inventory/sample inventory/mycluster

# Update the inventory file with your worker nodes IP and hostname
declare -a IPS=(your_worker_node_ip1 your_worker_node_ip2)
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

# Set up SSH access to the worker nodes
ssh-keygen
for node in ${IPS[@]}; do
    ssh-copy-id -i ~/.ssh/id_rsa.pub <your_username>@$node
done

# Join worker nodes to the Kubernetes cluster
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml --tags=kubelet
