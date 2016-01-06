#!/bin/bash

PROVISION_REPO=https://github.com/zenotech/zProvision.git

sudo apt-get install python-pip
sudo pip install --upgrade pip
sudo pip install ansible

git clone ${PROVISION_REPO}

cd zProvision/ansible
./setup.sh #Install dependencies
ansible-playbook playbooks/jenkins-slave.yml