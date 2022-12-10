curl -sfL https://get.k3s.io | sh -s - server \
  --token=12345 \
  --flannel-iface=eth1

echo "k() {
    sudo k3s kubectl \"\$@\"
}" >> /home/vagrant/.bashrc

source /home/vagrant/.bashrc

k apply -f "/home/vagrant/scripts/app-one-deployment.yaml"
k apply -f "/home/vagrant/scripts/app-two-deployment.yaml"
k apply -f "/home/vagrant/scripts/app-three-deployment.yaml"

k apply -f "/home/vagrant/scripts/app-one-service.yaml"
k apply -f "/home/vagrant/scripts/app-two-service.yaml"
k apply -f "/home/vagrant/scripts/app-three-service.yaml"