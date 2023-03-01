#!/bin/bash
var=""
install()
{
    var=$1
    echo "***********************************************"
    echo "[p3/scripts/install_all.sh] INSTALLING $var ! *"
    echo "***********************************************"
}

ok()
{
    echo "***********************************************"
    echo "[p3/scripts/install_all.sh] $var INSTALLED ! **"
    echo "***********************************************"
}

install_done()
{
    echo "***********************************************"
    echo "************** INSTALLATION OVER **************"
    echo "***********************************************"
}

# Install latest release of Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh ./get-docker.sh

# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
KUBERNETES_RELEASE=$(curl -sL https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBERNETES_RELEASE}/bin/linux/amd64/kubectl"

install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# INFO ON https://k3d.io/v5.4.6/
install K3D
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
ok

install_done
