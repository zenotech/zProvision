#!/bin/bash

PROVISION_REPO=github.com/zenotech/zProvision

sudo apt-get install pip
sudo pip install ansible

git clone ${PROVISION_REPO}

cd zProvision/ansible
./setup.sh #Install dependencies
ansible-playbook playbooks/jenkins-slave.yml