#!/bin/bash

sudo apt update
sudo apt install docker.io -y

cat /etc/group | grep docker | grep $USERNAME &>/dev/null

if ! [ "$?" -eq 0 ]; then
	# call yourself back after adding the user to the docker group
	sudo adduser $USERNAME docker
	$0
	# exit current run
	exit
fi

sudo service docker start

minikube start --driver=docker

if ! [ -s "/etc/bash_completion.d/kubectl" ]; then
	kubectl completion bash > /tmp/kubectl_completion
	sudo cp /tmp/kubectl_completion /etc/bash_completion.d/kubectl
	sudo cp complete_alias.sh /etc/bash_completion.d/

	cp ~/.bashrc ~/bashrc-backup-$(date +%s)
	cp bashrc-for-k8s ~/.bashrc
	. ~/.bashrc
fi

echo "Run 'source ~/.bashrc' and then 'h' for help. Also run 'alias' to view the new aliases."



