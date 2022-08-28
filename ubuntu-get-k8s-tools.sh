#!/bin/bash

cd /tmp

# general

sudo apt update
sudo apt install docker.io curl -y
sudo systemctl enable docker.service
#sudo adduser $USERNAME docker
#sudo service docker restart

# minikube

 curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
 sudo install minikube-linux-amd64 /usr/local/bin/minikube

# kubectl

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo install kubectl /usr/local/bin/kubectl

#if ! [ -s "/etc/bash_completion.d/kubectl" ]; then
	kubectl completion bash > /tmp/kubectl_completion
	sudo cp -v /tmp/kubectl_completion /etc/bash_completion.d/kubectl
	
	curl -k -O https://raw.githubusercontent.com/ohadm2/k8s-tools-installer/master/complete_alias.sh
	
	sudo cp -v complete_alias.sh /etc/bash_completion.d/
	
	#chmod +x /etc/bash_completion.d/complete_alias.sh
	#chmod +x /etc/bash_completion.d/kubectl
	
	curl -k -O https://raw.githubusercontent.com/ohadm2/k8s-tools-installer/master/bashrc-for-k8s-21-12-2021
	
	cp -v ~/.bashrc ~/bashrc-backup-$(date +%s)
	cp -v bashrc-for-k8s-21-12-2021 ~/.bashrc
	. ~/.bashrc
#fi

# helm

curl -LO https://get.helm.sh/helm-v3.9.4-linux-amd64.tar.gz

tar -xzf helm-v3.9.4-linux-amd64.tar.gz

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

echo Env stuff:
echo -------------------

ls -lh ~/.bashrc*
ls -lh /etc/bash_completion.d



echo

