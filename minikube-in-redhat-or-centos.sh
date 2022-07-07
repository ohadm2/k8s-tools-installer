#!/bin/bash

cd /tmp/

sudo yum config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

if ! [ -s "/usr/bin/kubectl" ]; then
    sudo curl -o /usr/bin/kubectl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    
    if [ -s "/usr/bin/kubectl" ]; then
        sudo chmod +x /usr/bin/kubectl
    fi
fi

if ! [ -s "/usr/bin/helm" ]; then
    sudo curl -O https://get.helm.sh/helm-v3.9.0-linux-amd64.tar.gz
    sudo tar -xzf helm-v3.9.0-linux-amd64.tar.gz
    sudo install linux-amd64/helm /usr/bin/helm
fi

sudo yum install git -y

sudo yum install docker-ce --allowerasing --nobest -y

sudo service docker start

sudo service docker status --no-pager

if [ "$?" -eq 0 ]; then
    cat /etc/group | grep docker | grep $USERNAME &>/dev/null

    if ! [ "$?" -eq 0 ]; then      
        sudo usermod -a -G docker $USERNAME
    fi

    if ! [ -s "/usr/bin/minikube" ]; then
        curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
        sudo install minikube-linux-amd64 /usr/bin/minikube
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

    #if [ -x "/usr/bin/minikube" ]; then
    #    minikube start --driver=docker
        
    #    if [ "$?" -eq 0 ]; then
    #        kubectl get pods
    #    fi
    #fi
    
    echo
    echo
    
    echo "Run 'source ~/.bashrc' and then 'h' for help. Also run 'alias' to view the new aliases."
    
    echo "Run 'minikube start --driver=docker' to get k8s working via minikube ..."
    
    # relogin with the new group changes
    newgrp docker
else
    echo "Error Occurred while trying to run the docker daemon! Aborting ..."
fi


