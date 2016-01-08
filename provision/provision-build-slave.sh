#!/bin/sh

PROVISION_REPO=https://github.com/zenotech/zProvision.git

sudo apt-get -y install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get -y install ansible
sudo -H apt-get -y install git

git clone ${PROVISION_REPO}

cd zProvision/ansible
sudo -H sh ./setup.sh #Install dependencies
echo "[ci-build]
localhost ansible_connection=local
" > host_inventory
ansible-playbook playbooks/build-slave.yml -i host_inventory

#Set git user config

git config --global user.email 'jenkins@zenotech.com'
git config --global user.name 'Jenkins CI'

