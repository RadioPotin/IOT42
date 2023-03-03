
kubectl create namespace gitlab

helm repo add gitlab https://charts.gitlab.io/
helm repo update

helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.edition=ce \
  --set gitlab-runner.install=false \
  --set global.hosts.domain=example.com \
  --set global.hosts.externalIP=10.0.0.10 \
  --set certmanager-issuer.email=me@example.com \
  -n gitlab

# watch kubectl get all -n gitlab
# helm status gitlab -n gitlab

# GitLab would’ve automatically created a random password for root user
# kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -ojsonpath='{.data.password}' | base64 --decode ; echo

echo "*********************************************************"
echo "*********************************************************"
echo "WAITING FOR PODS... *************************************"

kubectl wait --for=condition=available deployments --all -n gitlab

echo "TYPE THE FOLLOWING TO ACCESS THE GITLAB SERVICE: ********"
echo "kubectl port-forward svc/gitlab-webservice-default -n gitlab 8082:8080"

echo "*********************************************************"
echo "*********************************************************"
