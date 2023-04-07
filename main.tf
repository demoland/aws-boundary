data "aws_ami" "ubuntu_focal" {
  owners      = ["self"]
  most_recent = true
  filter {
    name   = "name"
    values = ["packer_AWS_UBUNTU_20.04_*"]
  }
}

locals {
  ami_id          = data.aws_ami.ubuntu_focal.image_id
  cidr_block      = data.terraform_remote_state.vpc.outputs.vpc_cidr
  key_name        = data.terraform_remote_state.vpc.outputs.management_key
  my_ip           = var.my_ip
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  public_subnet_0 = element(data.terraform_remote_state.vpc.outputs.public_subnet_ids, 0)
  public_subnet_1 = element(data.terraform_remote_state.vpc.outputs.public_subnet_ids, 1)
  public_subnets  = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  region          = data.terraform_remote_state.vpc.outputs.region
  ssh_sg          = data.terraform_remote_state.vpc.outputs.ssh_sg
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_instance" "boundary" {
  count                       = 1
  ami                         = local.ami_id
  instance_type               = "t3.medium"
  key_name                    = local.key_name
  monitoring                  = true
  vpc_security_group_ids      = [element(aws_security_group.boundary.*.id, 1), local.ssh_sg]
  subnet_id                   = local.public_subnet_1
  associate_public_ip_address = true
  tags = {
    Name = "boundary-server-${count.index}"
  }

  user_data = <<EOF
#!/bin/bash
#
#
#############################################
[ -t <&0 ] || exec >> /tmp/build.out

echo "Installed with Packer Image: ${local.ami_id}"
sudo apt-get update
sudo apt install -y net-tools \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    unzip  \
    docker-ce \
    docker-ce-cli \
    containerd.io

cd /tmp

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
EOF

}
