#!/bin/bash

HELM_FILE_NAME="helm-v3.10.2-linux-amd64.tar.gz"

PROJECT_DIR="/tmp/minikube-in-ubuntu"

if [ -d "$PROJECT_DIR" ]; then
    rm -rf $PROJECT_DIR
fi

mkdir -p $PROJECT_DIR

cd $PROJECT_DIR

sudo apt-get update
sudo apt-get install -y git apt-transport-https ca-certificates curl docker.io

#sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add
#sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

if [ -s "/etc/apt/sources.list.d/kubernetes.list" ]; then
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
fi

sudo apt update

sudo apt install -y kubectl

sudo curl -LO https://get.helm.sh/$HELM_FILE_NAME
sudo tar -xzf $HELM_FILE_NAME
sudo install linux-amd64/helm /usr/local/bin/helm

sudo systemctl start docker
sudo systemctl status docker --no-pager

if [ "$?" -eq 0 ]; then
    cat /etc/group | grep docker | grep $USERNAME &>/dev/null

    if ! [ "$?" -eq 0 ]; then      
        sudo usermod -a -G docker $USERNAME
    fi

    if ! [ -s "/usr/local/bin/minikube" ]; then
        curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
        sudo install minikube-linux-amd64 /usr/local/bin/minikube
    fi
    
    if ! [ -s "/etc/bash_completion.d/kubectl" ]; then
        if [ -s `which git` ]; then
            if [ -d "k8s-tools-installer" ]; then
                rm -rf k8s-tools-installer
            fi
            
            git clone https://github.com/ohadm2/k8s-tools-installer.git
            
            cd k8s-tools-installer

            kubectl completion bash > /tmp/kubectl_completion
            sudo install /tmp/kubectl_completion /etc/bash_completion.d/kubectl
            sudo install complete_alias.sh /etc/bash_completion.d/

            cp ~/.bashrc ~/bashrc-backup-$(date +%s)
            cp bashrc-for-k8s* ~/.bashrc
            
            /etc/bash_completion.d/kubectl
            /etc/bash_completion.d/complete_alias.sh
        fi
    fi
        
    echo "minikube version: $(minikube version)"
    echo "kubectl version: $(kubectl version)"
    echo "helm version: $(helm version)"

    #if [ -x "/usr/local/bin/minikube" ]; then
    #    minikube start --driver=docker
        
    #    if [ "$?" -eq 0 ]; then
    #        kubectl get pods
    #    fi
    #fi
    
    echo "Run 'source ~/.bashrc' and then 'h' for help. Also run 'alias' to view the new aliases."
    
    echo "Run 'minikube start --driver=docker' to get k8s working via minikube ..."
    
    # relogin with the new group changes
    newgrp docker
else
    echo "Error Occurred while trying to run the docker daemon! Aborting ..."
fi


