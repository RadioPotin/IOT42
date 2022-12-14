#!/bin/bash

# k3s installation as server
curl -sfL https://get.k3s.io |                          \
    K3S_KUBECONFIG_MODE="644"                           \
    K3S_NODE_NAME="${VM_SERVER_HOSTNAME}"               \
    INSTALL_K3S_EXEC="server --node-ip ${VM_SERVER_IP} --docker --disable traefik" \
    sh -

echo 'alias k="/usr/local/bin/k3s kubectl"' >> .bashrc
