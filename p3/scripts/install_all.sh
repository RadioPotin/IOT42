#!/bin/bash
var=""
install()
{
    var=$1
    echo "***********************************************"
    echo "[p3/scripts/install_all.sh] INSTALLING $var ..."
    echo "***********************************************"
}

ok()
{
    echo "***********************************************"
    echo "[p3/scripts/install_all.sh] $var INSTALLED !"
    echo "***********************************************"
}

install_done()
{
    echo "***********************************************"
    echo "********* INSTALLATION OVER ********"
    echo "***********************************************"
}

sudo usermod -aG root ${USER}
sudo usermod -aG root vagrant

# WILL FILL THIS SCRIPT WITH NECESSARY COMMANDS ONCE GUEST OS IS SELECTED

install "EOL VAULT REPOS"
ok

install "SYSTEM UPDATE"
ok

install "UTILITIES AND OPTIONNALS"
ok

install "DOCKER"
ok

# INFO ON https://www.tecmint.com/install-a-kubernetes-cluster-on-centos-8/
install "KUBECTL"
ok

# INFO ON https://k3d.io/v5.4.6/
install K3D
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
ok

install_done
