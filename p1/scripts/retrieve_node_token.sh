#!/bin/bash

# get master node token from Master
rsync -azqP -e 'ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' vagrant@${VM_SERVER_IP}:/home/vagrant/node_token /home/vagrant/node_token
