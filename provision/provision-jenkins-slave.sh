#!/bin/sh

PROVISION_REPO=https://github.com/zenotech/zProvision.git

sudo -H apt-get -y install python-pip python-dev build-essential
sudo -H pip install --upgrade pip
sudo -H pip install ansible

git clone ${PROVISION_REPO}

cd zProvision/ansible
sudo -H ./setup.sh #Install dependencies
echo "[ci-slave]
localhost ansible_connection=local
" > host_inventory
ansible-playbook playbooks/jenkins-slave.yml -i host_inventory
