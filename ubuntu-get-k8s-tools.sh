#!/bin/bash

cd /tmp

# general

sudo apt update
sudo apt install docker.io curl -y
sudo systemctl enable docker.service
sudo adduser $USERNAME docker
sudo service docker restart

# minikube

 curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
 sudo install minikube-linux-amd64 /usr/local/bin/minikube

# kubectl

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo install kubectl /usr/local/bin/kubectl


# helm

curl -LO https://get.helm.sh/helm-v3.5.3-linux-amd64.tar.gz

tar -xzf helm-v3.5.3-linux-amd64.tar.gz

sudo install linux-amd64/helm /usr/local/bin/helm


echo
echo kubectl version:
echo -------------------

kubectl version

echo
echo minikube version:
echo -------------------

minikube version

echo
echo helm version:
echo -------------------

helm version

echo

