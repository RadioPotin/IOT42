
echo "in case of failure ensure prep_env.sh executed properly"

echo "installing k3d"
# this should also install k9s, kubie & kubectl
brew install k3d
# curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "configuring k3d"
k3d cluster create iot \
    --api-port 6443 \
    --servers 1 \
    --agents 2 \
    --port 8080:80@loadbalancer \
    --port 8443:443@loadbalancer \
    --verbose
kubectl -n kube-system wait --for=condition=complete --timeout=-1s jobs/helm-install-traefik-crd
kubectl -n kube-system wait --for=condition=complete --timeout=-1s jobs/helm-install-traefik

echo "creating appropriate namespaces"
kubectl create namespace argocd
kubectl create namespace dev

echo "install helm"
brew install helm

echo "install argocd"
kubie ctx k3d-iot
kubie ns argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm install -n argocd argocd argo/argo-cd --version 5.19.14
kubectl wait --for=condition=Ready --timeout=-1s pods --all -n argocd
brew install argocd

echo "configuring argocd and demo app"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d 

kubectl port-forward service/argocd-server -n argocd 6565:443 &

argocd login argocd-server --port-forward --port-forward-namespace argocd --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
#### A MODIFIER PAR APP CIBLE WILL
argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default --port-forward --port-forward-namespace argocd
argocd app sync guestbook --port-forward --port-forward-namespace argocd 

#### A TESTER
argocd app create --repo https://github.com/RadioPotin/IOT42.git --revision dev/pgueugno --path p3/confs --dest-server https://kubernetes.default.svc --dest-namespace dev --port-forward --port-forward-namespace argocd --sync-policy auto
kubectl wait --for=condition=Ready --timeout=-1s pods --all -n dev
# argocd cluster add $(kubectl config get-contexts -o name) -y

