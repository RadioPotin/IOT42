#!/bin/bash

curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/cloud/deploy.yaml -O
k apply -f deploy.yaml
