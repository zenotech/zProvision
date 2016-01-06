#!/bin/sh

PROVISION_REPO=https://github.com/zenotech/zProvision.git

sudo -H apt-get -y install ansible

git clone ${PROVISION_REPO}

cd zProvision/ansible
sudo -H sh ./setup.sh #Install dependencies
echo "[ci-slave]
localhost ansible_connection=local
" > host_inventory
ansible-playbook playbooks/jenkins-slave.yml -i host_inventory
