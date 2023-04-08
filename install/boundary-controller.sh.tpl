#!/bin/bash
# install Boundary Worker
#############################################
OUTPUT=/tmp/build.out
exec >> $OUTPUT

#
echo "Installed with Packer Image: ${ami_id}"
sudo apt-get update
sudo apt install -y net-tools \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    unzip  

### HOSTINFO ###

ROLE=boundary
echo "Role: $ROLE"
IP=$(curl -s 169.254.169.254/latest/meta-data/local-ipv4)
echo "IP: $IP"
ID=${count}
echo "COUNT: $ID"
HOSTNAME="boundary-server-${count}"
echo "Setting Hostname To: $HOSTNAME"
hostnamectl set-hostname $HOSTNAME
hostnamectl
echo "Adding to /etc/hosts"

### HOSTINFO ###

### INSTALL BOUNDARY ###

echo "Installing Boundary" 
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install boundary
echo "Boundary Installed"

### INSTALL BOUNDARY ###
