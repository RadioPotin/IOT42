# READ BEFORE DIVING

The Vagrantfile is very minimal.

The provision script install a basic k3s server, copy all the configuration .yaml files and additional alias `k` to ease development.

The ingress is configured to have the 2 hosts `app1.com` and `app2.com` linked to the backends, and a defaultBackend for every other hosts.

As such, services are reachable from the outside with an automatically-assigned port for each around `:31000` without use of Ingress. According to the subject, it should not be like this.

Next steps in my opinion is to understand better how port works (ports exposed, ports inside the cluster, ingress ports).

# Useful commands

To work with k3s:

```bash
k() {
  sudo k3s kubectl "$@"
}
```

```bash
k get node -o wide # To show all nodes of a cluster
```

# Deployments and services

For deployments AND for services, .yaml files must be run using `k apply -f ./path/to/file.yaml`

When services are applied, environment variables are not reset to consider new env like the open port.

Scale your deployments to 0, then to initial value (here, 1):

```
k scale deployment my-deployment-slug --replicas=0
k scale deployment my-deployment-slug --replicas=1
```

Print the env again to see it changed.

# Exposing a service to the world
This is managed by ServiceType (https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)

# Redirect traffic depending of the "Host" HTTP header
We use Ingress (https://kubernetes.io/docs/concepts/services-networking/ingress/).
This is NOT to export port to the world. But to redirect already open traffic to the right services?

https://kubernetes.github.io/ingress-nginx/deploy/#quick-start

# Bibliography

## k3s

https://docs.k3s.io/reference/server-config

https://docs.k3s.io/reference/agent-config

## Vagrant

https://developer.hashicorp.com/vagrant/docs/vagrantfile/machine_settings

https://developer.hashicorp.com/vagrant/docs/multi-machine
