#!/bin/bash

echo "\t\nyum UPDATE...\n"
sudo uname -a
sudo yum check-update
sudo yum -y install net-tools
sudo yum -y update

curl https://releases.rancher.com/install-docker/19.03.sh | sh

# k3s installation as server
echo "Installing K3s"

curl -sfL https://get.k3s.io |                          \
    K3S_KUBECONFIG_MODE="644"                           \
    K3S_NODE_NAME="${VM_SERVER_HOSTNAME}"               \
    INSTALL_K3S_EXEC="server --bind-address=${VM_SERVER_IP} --node-ip=${VM_SERVER_IP} --tls-san ${VM_SERVER_HOSTNAME} --advertise-address=${VM_SERVER_IP} --docker" \
    sh -

echo 'alias k="/usr/local/bin/k3s kubectl"' >> .bashrc

source .bashrc

echo "Deploy apps"

/usr/local/bin/k3s kubectl apply -f /vagrant/config/app1.yaml -n kube-system
/usr/local/bin/k3s kubectl apply -f /vagrant/config/app2.yaml -n kube-system
/usr/local/bin/k3s kubectl apply -f /vagrant/config/app3.yaml -n kube-system
/usr/local/bin/k3s kubectl apply -f /vagrant/config/ingress.yaml -n kube-system
