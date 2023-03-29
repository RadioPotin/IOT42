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
sudo apt autoremove -y docker.io
sudo apt install -y docker.io
sudo groupadd docker
sudo usermod -aG docker dariocp


# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
if [ ! -f /usr/local/bin/kubectl ] ; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    echo 'alias k="/usr/local/bin/kubectl"' >> /home/$USER/.bashrc
    source /home/$USER/.bashrc
    rm kubectl
fi

# INFO ON https://k3d.io/v5.4.6/
install K3D
if [ ! -f /usr/local/bin/k3d ] ; then
    curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
fi
ok

install_done
