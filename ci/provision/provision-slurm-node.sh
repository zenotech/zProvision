#!/bin/sh

set -e

PROVISION_REPO=https://github.com/zenotech/zProvision.git

sudo -H yum -y install git https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
sudo -H yum -y groupinstall "Development Tools"
sudo -H yum -y install python-pip python-devel libffi-devel openssl-devel

sudo -H pip install --upgrade ansible jinja2

if [ ! -d zProvision ]; then
    git clone ${PROVISION_REPO}
else
    pushd zProvision
    git pull
    popd
fi

cd zProvision/ci/ansible
sudo -H sh ./setup.sh #Install dependencies
echo "[slurm-slave]
localhost ansible_connection=local slurm_nodename=$1
" > host_inventory
ansible-playbook playbooks/slurm-slave.yml -i host_inventory
