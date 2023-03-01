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

# INFO ON https://k3d.io/v5.4.6/
install K3D
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
ok

install_done
