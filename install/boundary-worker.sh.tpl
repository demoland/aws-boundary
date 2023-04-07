#!/bin/bash
# install Boundary Worker
#############################################
OUTPUT=/tmp/build.out
exec >> $OUTPUT

#
echo "Installed with Packer Image: ${local.ami_id}"
sudo apt-get update
sudo apt install -y net-tools \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    unzip  

### HOSTINFO ###

ROLE=boundary
IP=$(curl -s 169.254.169.254/latest/meta-data/local-ipv4)
ID=${count.index}
HOSTNAME="boundary-server-${count.index}"
echo $HOSTNAME > /etc/hostname
hostname $HOSTNAME 

### HOSTINFO ###


### INSTALL BOUNDARY ###

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install boundary

### INSTALL BOUNDARY ###
