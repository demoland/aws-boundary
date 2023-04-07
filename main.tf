data "aws_ami" "ubuntu_focal" {
  owners      = ["self"]
  most_recent = true
  filter {
    name   = "name"
    values = ["packer_AWS_UBUNTU_20.04_*"]
  }
}

locals {
  public_subnet_0 = element(data.terraform_remote_state.vpc.outputs.public_subnet_ids, 0)
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  // This AMI is the Ubuntu 20.04 located in us-east-2
  my_ip           = var.my_ip
  cidr_block      = var.cidr_block
  ami_id          = data.aws_ami.ubuntu_focal.image_id
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  public_subnets  = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  key_name        = data.terraform_remote_state.vpc.outputs.management_key
  ssh_sg          = data.terraform_remote_state.vpc.outputs.ssh_sg
}

resource "aws_instance" "boundary" {
  count         = 1
  ami           = local.ami_id
  instance_type = "t3.medium"
  key_name      = local.key_name
  monitoring    = true
  vpc_security_group_ids      = [element(aws_security_group.consul.*.id, 1), local.ssh_sg]
  subnet_id                   = local.public_subnet_0
  iam_instance_profile        = aws_iam_instance_profile.consul.name
  associate_public_ip_address = true
  tags = {
    CONSUL = "SERVER"
    Name   = "consul-server-${count.index}"
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

resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_key_pair" "management_key" {
  key_name   = "management"
  public_key = var.management_pubkey
}
