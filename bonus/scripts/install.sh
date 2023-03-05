kubie ctx
kubectl create namespace gitlab
kubie ns gitlab

helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade -n gitlab --install gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.hosts.domain=iot.com \
  --set global.hosts.externalIP=10.10.10.10 \
  --set certmanager-issuer.email=me@example.com \
  --set postgresql.image.tag=13.6.0 \
  --set global.kas.enabled=false \
  --set prometheus.install=false \
  --set nginx-ingress.enabled=false \
  --set global.ingress.provider=traefik \
  --set global.ingress.class=traefik \
  --set global.hosts.https=false

helm upgrade -n argocd argocd argo/argo-cd --set configs.secret.gitlabSecret=gitlab-cred

# Getting root password
kubectl get secret -n gitlab gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode ; echo

# glpat-nmoYFDDix-EwAa8_p2xR Deploy token de test

# glpat-QF4pRehPuDg4WMY84x_3 Access Token de test

argocd login argocd-server --port-forward --port-forward-namespace argocd --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# argocd repo add http://gitlab.iot.com:8080/gitlab-instance-558630eb/bonus.git --port-forward --port-forward-namespace argocd --username admin --password glpat-QF4pRehPuDg4WMY84x_3


argocd app create pgueugno-bonus --repo http://gitlab.iot.com:8080/gitlab-instance-558630eb/bonus.git --revision dev/pgueugno --path p3/confs  --sync-policy auto --dest-server https://kubernetes.default.svc --dest-namespace dev --port-forward --port-forward-namespace argocd
kubectl wait --for=condition=Ready --timeout=-1s pods --all -n dev

argocd app create pgueugno-bonus --repo http://gitlab.iot.com:8080/gitlab-instance-558630eb/bonus2.git --revision dev/pgueugno --path p3/confs  --sync-policy auto --dest-server https://kubernetes.default.svc --dest-namespace dev --port-forward --port-forward-namespace argocd