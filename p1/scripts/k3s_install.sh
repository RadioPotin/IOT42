#!/bin/bash

if [ ${K3S_MODE} == "AGENT" ]; then
    # k3s installation as agent
    curl -sfL https://get.k3s.io |                          \
        K3S_KUBECONFIG_MODE="644"                           \
        K3S_TOKEN_FILE="/home/vagrant/node_token"           \
        K3S_URL="https://${VM_SERVER_IP}:6443"              \
        K3S_NODE_NAME="${VM_WORKER_HOSTNAME}"               \
        K3S_NODE_IP="${VM_WORKER_IP}"                       \
        INSTALL_K3S_EXEC="agent --node-ip ${VM_WORKER_IP} --flannel-iface eth1"  \
        sh -
else
    # k3s installation as server
    curl -sfL https://get.k3s.io |                          \
        K3S_KUBECONFIG_MODE="644"                           \
        K3S_NODE_NAME="${VM_SERVER_HOSTNAME}"               \
        INSTALL_K3S_EXEC="server --node-ip ${VM_SERVER_IP} --flannel-iface eth1" \
        sh -

    # save kubectl node token
    cat /var/lib/rancher/k3s/server/node-token > /home/vagrant/node_token
fi
# add "k" alias for k3s
echo 'alias k="/usr/local/bin/k3s kubectl"' >> .bashrc
