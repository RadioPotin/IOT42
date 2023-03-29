
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

kubectl create namespace gitlab

helm repo add gitlab https://charts.gitlab.io/
helm repo update

#helm upgrade --install gitlab gitlab/gitlab \
#  --timeout 600s \
#  --set global.edition=ce \
#  --set gitlab-runner.install=false \
#  --set global.hosts.domain=example.com \
#  --set global.hosts.externalIP=10.0.0.10 \
#  --set certmanager-issuer.email=me@example.com \
#  -n gitlab


helm install gitlab gitlab/gitlab \
  --namespace gitlab \
  --set global.edition=ce \
  --set gitlab-runner.install=false \
  --set certmanager-issuer.email=dariopinto@hotmail.fr \
  --set global.hosts.domain=example.com \
  --set global.nginx-ingress.enableTLS=true \
  --set global.hosts.externalIP=127.0.0.1

# watch kubectl get all -n gitlab
# helm status gitlab -n gitlab

# GitLab would’ve automatically created a random password for root user
# kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -ojsonpath='{.data.password}' | base64 --decode ; echo

echo "*********************************************************"
echo "*********************************************************"
echo "WAITING FOR PODS... *************************************"

kubectl wait --for=condition=available deployments --all -n gitlab
# kubectl get pods -n gitlab -w

#kubectl -n gitlab expose deployment gitlab --type=LoadBalancer --name=gitlab
kubectl -n gitlab get services

echo "TYPE THE FOLLOWING TO ACCESS THE GITLAB SERVICE: ********"
echo "kubectl port-forward svc/gitlab-webservice-default -n gitlab 8082:8080"
echo "PASSWORD:"

kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -ojsonpath='{.data.password}' | base64 --decode ; echo

# helm delete gitlab -n gitlab
# kubectl delete namespace gitlab
echo "*********************************************************"
echo "*********************************************************"
