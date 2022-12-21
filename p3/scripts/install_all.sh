#!/bin/bash

var=""
install() {
    var=$1
    echo "[p3/scripts/install_all.sh] Installing $var ..."
}

ok() {
    echo "[p3/scripts/install_all.sh] $var OK !"
}

echo "CHANGING TO VAULT REPO DUE TO EOL"
cd /etc/yum.repos.d/
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

echo "UPDATING SYSTEM"
sudo uname -a
sudo yum check-update
sudo yum -y install net-tools
sudo yum -y update

export PATH=$PATH:/usr/local/bin
echo "export PATH=$PATH:/usr/local/bin" >> .bashrc
source .bashrc

install "Utilities and optionnals"

sudo yum install -y net-tools yum-utils
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo yum install -y neovim python3-neovim

ok "Utilities and optionnals"

# INFO ON https://docs.docker.com/engine/install/centos/

install "Docker on centos"

sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io

# https://jolthgs.wordpress.com/2020/05/07/first-step-with-docker-in-arch-linux/

sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service
sudo systemctl start docker

# add user to docker group

sudo usermod -aG docker ${USER}

ok "Docker on centos"

# INFO ON https://k3d.io/v5.4.6/

install k3d

curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

ok k3d

# INFO ON https://www.tecmint.com/install-a-kubernetes-cluster-on-centos-8/

install kubectl

sudo cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

sudo yum install -y kubectl

ok kubectl

echo "/!\\ DONE /!\\"
