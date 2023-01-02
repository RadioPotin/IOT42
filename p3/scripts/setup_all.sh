#!/bin/bash

echo "SETUP SCRIPT"


var=""
setup()
{
    var=$1
    echo "*********************************************"
    echo "[p3/scripts/setup_all.sh] SETTING UP $var ..."
    echo "*********************************************"
}

ok()
{
    echo "*********************************************"
    echo "[p3/scripts/setup_all.sh] $var OK !"
    echo "*********************************************"
}

export PATH=$PATH:/usr/local/bin
echo "export PATH=$PATH:/usr/local/bin" >> .bashrc
source .bashrc

setup K3D

# INFO ON https://k3d.io/v5.4.6/usage/exposing_services/


sudo /usr/local/bin/k3d cluster create p3   \
  --api-port 6443 --servers 1 --agents 2    \
  --port 8080:80@loadbalancer               \
  --port 8443:443@loadbalancer

ok

sudo mv /root/.kube /home/vagrant/.kube

sudo chown -R $USER:$USER /home/$USER/.kube/

#setup KUBECTL

## INFO ON https://serverfault.com/questions/981012/kubernetes-wait-on-pod-job/1013636
#kubectl -n kube-system wait --for=condition=complete --timeout=-1s jobs/helm-install-traefik-crd
#kubectl -n kube-system wait --for=condition=complete --timeout=-1s jobs/helm-install-traefik
#kubectl get jobs -n kube-system

#ok
