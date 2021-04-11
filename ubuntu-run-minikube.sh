#!/bin/bash

sudo apt update
sudo apt install docker.io -y

sudo adduser $USERNAME docker

sudo service docker start

newgrp docker

sudo minikube start --driver=docker

sudo kubectl completion bash > /etc/bash_completion.d/kubectl
sudo cp complete_alias.sh /etc/bash_completion.d/

cp ~/.bashrc ~/bashrc-backup-$(date +%s)
cp bashrc-for-k8s ~/.bashrc
source ~/.bashrc

h



