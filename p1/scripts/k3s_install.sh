#!/bin/bash

# ? If you wish to use a smaller OS like opensuse/Leap-15.4.x86_64
# ? be careful to specify a compatible k3s version with INSTALL_K3S_VERSION=v1.23.14+k3s1

if [ ${K3S_MODE} == "AGENT" ]; then
    # k3s installation as agent
    curl -sfL https://get.k3s.io |                          \
        K3S_KUBECONFIG_MODE="644"                           \
        K3S_NODE_NAME="${VM_WORKER_HOSTNAME}"               \
        K3S_TOKEN="$(cat /home/vagrant/node_token)"         \
        K3S_URL="https://192.168.56.110:6443"              \
        INSTALL_K3S_EXEC="agent  --node-ip 192.168.56.111 --flannel-iface eth1"  \
        sh -
else
    # k3s installation as server
    curl -sfL https://get.k3s.io |                          \
        K3S_KUBECONFIG_MODE="644"                           \
        K3S_NODE_NAME="${VM_SERVER_HOSTNAME}"               \
        INSTALL_K3S_EXEC="server --tls-san "https://192.168.56.110:6443" --node-external-ip 192.168.56.110 --flannel-iface eth1" \
        sh -

    # save master node token and rancher config for kubectl tool
    cat /var/lib/rancher/k3s/server/node-token > /home/vagrant/node_token
    cat /etc/rancher/k3s/k3s.yaml > /home/vagrant/configRancher
fi
# add "k" alias for k3s
echo 'alias k="/usr/local/bin/k3s kubectl"' >> .bashrc
