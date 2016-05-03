#!/bin/sh

set -e

PROVISION_REPO=https://github.com/zenotech/zProvision.git

sudo -H apt-get -y install ansible git

git clone ${PROVISION_REPO}

cd zProvision/ci/ansible
sudo -H sh ./setup.sh #Install dependencies
echo "[ci-slave]
localhost ansible_connection=local
" > host_inventory
ansible-playbook playbooks/jenkins-slave.yml -i host_inventory

# Install ec2 vagrant plugin
vagrant plugin install vagrant-aws
