
echo "in case of failure ensure prep_env.sh executed properly"

echo "installing k3d"
# this should also install k9s, kubie & kubectl
brew install k3d

echo "configuring k3d"
k3d cluster create iot \
    --api-port 6443 \
    --servers 1 \
    --agents 2 \
    --port 8080:80@loadbalancer \
    --port 8443:443@loadbalancer \
    # --port 30888:8888@loadbalancer \
    --port 8888:8888@loadbalancer \
    --verbose
kubectl -n kube-system wait --for=condition=complete --timeout=-1s jobs/helm-install-traefik-crd
kubectl -n kube-system wait --for=condition=complete --timeout=-1s jobs/helm-install-traefik

echo "creating appropriate namespaces"
kubectl create namespace argocd
kubectl create namespace dev

echo "install helm"
brew install helm

echo "install argocd"
k3d kubeconfig get iot > ~/.kube/config
kubie ctx k3d-iot
kubie ns argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm install -n argocd argocd argo/argo-cd --version 5.19.14
kubectl wait --for=condition=Ready --timeout=-1s pods --all -n argocd
brew install argocd

echo "configuring argocd and demo app"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d 

kubectl port-forward service/argocd-server -n argocd 6565:443 &
# kubectl port-forward service/argocd-server -n argocd 8443:443 &
echo "access argocd web ui at localhost:6565"

argocd login argocd-server --port-forward --port-forward-namespace argocd --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
argocd app create pgueugno-playground --repo https://github.com/RadioPotin/IOT42.git --revision dev/pgueugno --path p3/confs  --sync-policy auto --dest-server https://kubernetes.default.svc --dest-namespace dev --port-forward --port-forward-namespace argocd
kubectl wait --for=condition=Ready --timeout=-1s pods --all -n dev
# port-forward may go down after argocd sync
kubectl port-forward service/pgueugno-playground -n dev 8888:8888 &
echo "checking image version"
curl http://localhost:8888/


