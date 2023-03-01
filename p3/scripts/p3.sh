#!/bin/bash
var=""
setup()
{
    var=$1
    echo "*********************************************************"
    echo "[p3/scripts/setup_all.sh] SETTING UP $var ..."
    echo "*********************************************************"
}

ok()
{
    echo "*********************************************************"
    echo "[p3/scripts/setup_all.sh] $var SET UP !"
    echo "*********************************************************"
}

setup_start()
{
    echo "*********************************************************"
    echo "************* DOCKER,KUBECTL,K3D SETUP START ************"
    echo "*********************************************************"
}

setup_done()
{
    echo "*********************************************************"
    echo "************* DOCKER,KUBECTL,K3D SETUP DONE *************"
    echo "*********************************************************"
}

setup_start

setup "K3D"
k3d cluster create p3 \
  --api-port 6443 \
  --servers 1 \
  --agents 2 \
  --port 8080:80@loadbalancer \
  --port 8443:443@loadbalancer \
  --wait \
  --verbose
ok

setup "KUBECTL"
kubectl -n kube-system wait --for=condition=complete --timeout=-1s jobs/helm-install-traefik-crd
kubectl -n kube-system wait --for=condition=complete --timeout=-1s jobs/helm-install-traefik
kubectl get jobs -n kube-system
ok

setup "NAMESPACES"
kubectl create namespace argocd
kubectl create namespace dev
ok

setup "ARGOCD"
kubectl apply -f ../config/install_argocd.yaml -n argocd
echo "*********************************************************"
echo "***************** Waiting for pods... *******************"
echo "*********************************************************"
kubectl wait --for=condition=Ready --timeout=-1s pods --all -n argocd
kubectl apply -f ../config/argocd_ingress.yaml -n argocd
kubectl rollout status deployment argocd-server -n argocd
kubectl rollout status deployment argocd-redis -n argocd
kubectl rollout status deployment argocd-repo-server -n argocd
kubectl rollout status deployment argocd-dex-server -n argocd
# kubectl get pods -A -w
ok

setup "ARGOCD-CLI"
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
ok

echo "*********************************************************"
echo "Default Password for ARGOCD:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
echo "ID: admin"
echo "*********************************************************"

setup_done
