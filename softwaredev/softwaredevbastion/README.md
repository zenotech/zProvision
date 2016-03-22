

Install for OSX:

sudo port install vagrant
vagrant plugin install vagrant-aws
sudo port install ansible

sudo ansible-galaxy install -r requirements.yml

Required Environment VARS

export AWS_ACCESS_KEY=
export AWS_SECRET_KEY=
export AWS_KEYPAIR_NAME=
export PRIVATE_AWS_SSH_KEY_PATH=


Create and provison
vagrant up

Halt
vagrant halt

Terminate
vagrant destroy