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
 - Use an [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) in conjuntion with an [Ingress controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/), (we use [ingress-nginx](https://kubernetes.github.io/ingress-nginx/deploy/)) to expose HTTP/S routes to [Services inside the cluster](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)
 - [yaml files explained](https://www.youtube.com/watch?v=qmDzcu5uY1I)

## p3

Things to do:
 - install docker, k3d, [argocd](https://www.youtube.com/watch?v=MeU5_k9ssrs&t=1662s)
 - [create and configure k3d cluster with argocd](https://en.sokube.ch/post/gitops-on-a-laptop-with-k3d-and-argocd-1)

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

3. k3d, and what it is:

