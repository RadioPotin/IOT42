#!/bin/bash

echo "SETUP SCRIPT"


var=""
setup() {
    var=$1
    echo "[p3/scripts/install_all.sh] Installing $var ..."
}

ok() {
    echo "[p3/scripts/install_all.sh] $var OK !"
}

setup k3d

# INFO ON https://k3d.io/v5.4.6/usage/exposing_services/

k3d cluster create p3 --api-port 8080:80@loadbalancer --api-port 8888:8888@loadbalancer --api-port 8443:443@loadbalancer

setup kubectl

# INFO ON https://serverfault.com/questions/981012/kubernetes-wait-on-pod-job/1013636
kubectl get jobs -n kube-system
kubectl -n kube-system wait --for=condition=complete --timeout=-1s jobs/helm-install-traefik-crd
kubectl -n kube-system wait --for=condition=complete --timeout=-1s jobs/helm-install-traefik
kubectl get jobs -n kube-system
