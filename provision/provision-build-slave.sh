#!/bin/sh

PROVISION_REPO=https://github.com/zenotech/zProvision.git

sudo -H apt-get -y install ansible git

git clone ${PROVISION_REPO}

cd zProvision/ansible
sudo -H sh ./setup.sh #Install dependencies
echo "[ci-build]
localhost ansible_connection=local
" > host_inventory
ansible-playbook playbooks/build-slave.yml -i host_inventory
