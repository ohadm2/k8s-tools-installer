#!/bin/bash

if [ -s ~/bashrc-backup.old ]; then
  rm ~/bashrc-backup.old
fi

if [ -s ~/bashrc-backup ]; then
  mv ~/bashrc-backup ~/bashrc-backup.old
fi

cp ~/.bashrc ~/bashrc-backup

curl https://raw.githubusercontent.com/ohadm2/k8s-tools-installer/master/bashrc-for-k8s-06-09-2022 -o ~/.bashrc
