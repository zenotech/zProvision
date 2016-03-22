

Install for OSX:

sudo port install vagrant
vagrant plugin install vagrant-aws
sudo port install ansible

sudo ansible-galaxy install -r requirements.yml

Required Environment VARS

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_KEYPAIR_NAME=
export MY_PRIVATE_AWS_SSH_KEY_PATH=


Ensure that key above is added to ssh-agent
Check using ssh-add -l

In .ssh/config

Host dev.zenotech.com
 User ubuntu
 ForwardAgent yes

Host 10.0.10.1
 ProxyCommand ssh -A ubuntu@dev.zenotech.com -W %h:%p



Create and provison
vagrant up

Halt
vagrant halt

Terminate
vagrant destroy

To debug
export VAGRANT_LOG=debug

