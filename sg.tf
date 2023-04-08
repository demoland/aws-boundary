resource "aws_security_group" "boundary_controller" {
  name        = "boundary_controller"
  description = "Allow Boundary Controller traffic from client"
  vpc_id      = local.vpc_id

  ingress {
    description = "Server RPC"
    from_port   = 9200
    to_port     = 9200
    protocol    = "TCP"
    cidr_blocks = [local.my_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_boundary_client_connections"
  }
}
