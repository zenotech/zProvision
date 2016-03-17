

Install for OSX:

vagrant
sudo port install ansible

ansible-galaxy install -r requirements.yml

Required Environment VARS

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_KEYPAIR_NAME=
export MY_PRIVATE_AWS_SSH_KEY_PATH=


Create and provison
vagrant up

Halt
vagrant halt

Terminate
vagrant destroy