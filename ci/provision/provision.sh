#!/bin/bash

set -e

PROVISION_REPO=https://github.com/zenotech/zProvision.git

function bootstrap_debian {
    sudo -H apt-get -y update
    sudo -H apt-get -y install gcc git python-pip python-dev libffi-dev libssl-dev libyaml-dev
    sudo pip install setuptools
    sudo pip install ansible
}

function bootstrap_rh {
    sudo -H yum -y install git https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
    sudo -H yum -y groupinstall "Development Tools"
    sudo -H yum -y install python-pip python-devel libffi-devel openssl-devel

    sudo -H pip install --upgrade setuptools ansible jinja2
}

if [ -f /etc/debian_version ] ; then
    bootstrap_debian
fi

if [ -f /etc/redhat-release ] ; then
    bootstrap_rh
fi

git clone ${PROVISION_REPO}

cd zProvision/ci/ansible
sudo -H sh ./setup.sh #Install dependencies
echo "[all]
localhost ansible_connection=local
" > host_inventory
ansible-playbook -i host_inventory playbooks/$1.yml
