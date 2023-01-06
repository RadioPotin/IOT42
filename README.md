# IOT42

Introductory project to Kubernetes, using Vagrant

## p1

Setup two VM with a Vagrantfile.
Requirements:
  - Minimum Ressources:
    - 1 CPU
    - 512 MB of RAM
    - Dedicated IP on eth1
  - VM1 Hostname and IP: `dapintoS`, `192.168.56.110`
  - VM1 Hostname and IP: `tbaillySW`, `192.168.56.111`
  - Be able to connect with SSH to both machines
  - Install K3s on each machine + kubectl

## p2

Take the setup of P1.

Setup a VM with a Vagrantfile:
Requirements:
  - Hostname: `dapintoS`
  - IP: `192.168.56.110` 
  - FROM the HOSTMACHINE, access the apps on the machine based on the chosen domain name

Read the following:
 - [Configuring the app](https://kubernetes.io/docs/concepts/overview/working-with-objects/)
 - [deployment, service and ingress](https://dwdraju.medium.com/how-deployment-service-ingress-are-related-in-their-manifest-a2e553cf0ffb)
 - Use an [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) in conjuntion with an [Ingress controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/), (we use **traefik**) to expose HTTP/S routes to [Services inside the cluster](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)
 - [yaml files explained](https://www.youtube.com/watch?v=qmDzcu5uY1I)

## p3

Things to do:
 - install docker, k3d, [argocd](https://www.youtube.com/watch?v=MeU5_k9ssrs&t=1662s)
 - [create and configure k3d cluster with argocd](https://en.sokube.ch/post/gitops-on-a-laptop-with-k3d-and-argocd-1)
 - [Exposing services](https://k3d.io/v5.4.6/usage/exposing_services/)
   ```shell-session
   k3d cluster create p3                  \
   --api-port 6443 --servers 1 --agents 2 \
   --port 8080:80@loadbalancer            \
   --port 8443:443@loadbalancer           \
   --wait                                 \
   --verbose
   ```
 - [Waiting on jobs](https://serverfault.com/questions/981012/kubernetes-wait-on-pod-job/1013636)
   ```shell-session
   # These commands will wait for both of these jobs to finish before proceeding
   kubectl -n kube-system wait --for=condition=complete --timeout=-1s jobs/helm-install-traefik-crd
   kubectl -n kube-system wait --for=condition=complete --timeout=-1s jobs/helm-install-traefik
   ```
 - Creating namespaces
   ```shell-session
   kubectl create namespace argocd
   kubectl create namespace dev
   ```
 - [Getting started with argocd](https://argo-cd.readthedocs.io/en/stable/getting_started/)
   - Install and configure argocd 
     ```shell-session
     # Getting the installation script
     curl -o install_argocd.yaml https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
     # Modify installation script.
     # Precisely: deployment manifest for server, argocd-server, argocd with commands --insecure, --rootpath /argocd -> See https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#traefik-v22
     # applying the installation manifest to the cluster
     kubectl apply -f $CONFIG_PATH/config/install_argocd.yaml -n argocd
     ```
 - Be patient and wait for pods
   ```shell-session
   # Watching pods
   kubectl get pods -A w
   ```
 - Make argocd accessible
   ```shell-session
   # Create an Ingress for argocd-server without ssl certificate (hence --insecure option in install manifest) - See ./p3/config/argocd_ingress.yaml
   # Apply
   kubectl apply -f p3/config/argocd_ingress.yaml -n argocd
   ```
 - [Install CLI for argocd](https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#kubernetesingress-nginx)
   ```shell-session
   # retrieve binary
   curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
   # install binary
   sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
   rm argocd-linux-amd64
   ```
 - Retrieve default password
   ```shell-session
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
   ```

## bonus

Things to do:
 - Installing gitlab in a vm with [Vagrant](https://www.tecmint.com/install-and-configure-gitlab-on-centos-7/)
 - Same thing as p3 but the repo is installed in a local repo

## Vagrant

Vagrant enables users to create and configure lightweight, reproducible, and portable development environments.

Ruby script allowing to automatically deploy environments choosing from an array of providers.

For the subject, these chapters are needed:
- [Defining a Static IP](https://developer.hashicorp.com/vagrant/docs/networking/private_network)
- [Configuring a provider](https://developer.hashicorp.com/vagrant/docs/providers/configuration)
- [Shell provisioning](https://developer.hashicorp.com/vagrant/docs/provisioning/shell)
- [Triggering](https://developer.hashicorp.com/vagrant/docs/triggers/configuration)
- Installing a plugin for example: `$ vagrant plugin install vagrant-scp`

## Kubernetes

For the subject, these chapters are needed:
1. K3s, and [what it is](https://docs.k3s.io/) and [how to install it](https://docs.k3s.io/quick-start):
  - [Installing k3s as agent](https://docs.k3s.io/reference/agent-config)
  - [Installing k3s as server](https://docs.k3s.io/reference/server-config)

![Example arch](/assets/img/k3s-architecture-single-server.svg)

2. K8s, and what it is:
  - [Kubernetes API Deployment v1 Specification](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/deployment-v1/#DeploymentSpec)
  - [Kubernetes API Service v1 Specification](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/)
  - [Kubernetes API Ingress v1 Specification](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/ingress-v1/#IngressSpec)
  - [Kubernetes API Pods v1 Specification](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1)
  - [Kubernetes API Convention](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md#types-kinds)

3. [k3d](https://k3d.io/v5.4.6/), and what it is:
  - Difference between k3d and k3s:
      > One of the key differences is that k3d deploys Docker-based k3s Kubernetes clusters while k3s deploys a virtual machine-based Kubernetes cluster. K3d offers a more scalable version of k3s which might make it preferable to the standard k3s.
  - [Requirements prior to installation](https://k3d.io/v5.4.6/#requirements)
  - [k3d setup with argocd](https://www.techmanyu.com/setup-a-gitops-deployment-model-on-your-local-development-environment-with-k3s-k3d-and-argocd-4be0f4f30820)
  - [Example for deployment phase](https://www.youtube.com/watch?v=2WSJF7d8dUg&ab_channel=ThatDevOpsGuy)

