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
  public_subnet_2 = element(data.terraform_remote_state.vpc.outputs.public_subnet_ids, 2)
  public_subnets  = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  region          = data.terraform_remote_state.vpc.outputs.region
  ssh_sg          = data.terraform_remote_state.vpc.outputs.ssh_sg
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  private_key     = base64decode(var.private_key)
}

//https://developer.hashicorp.com/boundary/docs/getting-started/installing/production

resource "aws_instance" "boundary_controller" {
  count                       = 3
  ami                         = local.ami_id
  instance_type               = "t3.medium"
  key_name                    = local.key_name
  monitoring                  = true
  vpc_security_group_ids      = [aws_security_group.boundary_controller.id, local.ssh_sg]
  subnet_id                   = local.public_subnets[count.index]
  associate_public_ip_address = true
  tags = {
    Name = "boundary-controller-${count.index}"
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = local.private_key
    host        = self.private_ip
  }

  #https://developer.hashicorp.com/terraform/language/resources/provisioners/connection
  # Generate Init Script with variables

  provisioner "file" {
    content = templatefile("./install/boundary-controller.sh.tpl",
      {
        ami_id = local.ami_id
        count  = count.index
      }
    )
    destination = "/tmp/boundary-controller.sh"
  }

  # Execute Init Script
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/boundary-controller.sh",
      "/tmp/boundary-controller.sh",
    ]
  }
}
