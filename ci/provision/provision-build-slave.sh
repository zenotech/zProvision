#!/bin/sh

set -e

PROVISION_REPO=https://github.com/zenotech/zProvision.git

sudo -H apt-get -y install git python-pip python-dev
sudo pip install -U pip setuptools
sudo pip install ansible

git clone ${PROVISION_REPO}

cd zProvision/ci/ansible
sudo -H sh ./setup.sh #Install dependencies
echo "[ci-build]
localhost ansible_connection=local
" > host_inventory
ansible-playbook playbooks/build-slave.yml -i host_inventory

#Set git user config

git config --global user.email 'jenkins@zenotech.com'
git config --global user.name 'Jenkins CI'

