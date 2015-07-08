#!/bin/bash

# install epel
sudo rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo yum localinstall -y epel-release-6-8.noarch.rpm

# install sshpass(noninteractive ssh password provider)
sudo yum install -y sshpass

# generate rsa key
mkdir -p ~/.ssh
if [[ ! -f ~/.ssh/id_rsa ]]; then
  ssh-keygen -t rsa -q -f ~/.ssh/id_rsa -P ""
fi

# copy rsa key
cat ~/.ssh/id_rsa.pub | sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no vagrant@192.168.33.11 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

# install ansible
sudo yum install -y ansible

# configure host for ansible
cat <<EOF > hosts
[provision_dest]
192.168.33.11
EOF

# test connect
ansible -i hosts provision_dest -m ping