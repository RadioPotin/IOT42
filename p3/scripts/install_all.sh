#!/bin/bash

var=""
install() {
    var=$1
    echo "***********************************************"
    echo "[p3/scripts/install_all.sh] INSTALLING $var ..."
    echo "***********************************************"
}

ok() {
    echo "***********************************************"
    echo "[p3/scripts/install_all.sh] $var OK !"
    echo "***********************************************"
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

install "UTILITIES AND OPTIONNALS"

sudo yum install -y net-tools yum-utils
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo yum install -y neovim python3-neovim

ok

# INFO ON https://docs.docker.com/engine/install/centos/

install "DOCKER ON CENTOS"

sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io

# https://jolthgs.wordpress.com/2020/05/07/first-step-with-docker-in-arch-linux/

sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service
sudo systemctl start docker

# add user to docker group

sudo usermod -aG docker ${USER}
sudo usermod -aG docker vagrant

ok

# INFO ON https://www.tecmint.com/install-a-kubernetes-cluster-on-centos-8/

install KUBECTL

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
#sudo chown -R $USER:$USER /home/$USER/.kube/
## RUNNING AS USER
#export KUBECONFIG=$HOME/.kube/config
#echo 'export KUBECONFIG=$HOME/.kube/config' >> $HOME/.bashrc
#sudo chown -R $USER:$USER /home/$USER/.kube/
## RUNNING AS ROOT
#export KUBECONFIG=/home/vagrant/.kube/config
#echo 'export KUBECONFIG=/home/vagrant/.kube/config' >> /home/vagrant/.bashrc
#sudo chown -R vagrant:vagrant /home/vagrant/.kube/

ok

# INFO ON https://k3d.io/v5.4.6/

install K3D

curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

ok


echo "/!\\ DONE /!\\"
