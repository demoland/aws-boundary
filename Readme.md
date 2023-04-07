# HashiCorp Boundary Server Terraform Module

This Terraform module deploys a HashiCorp Boundary server on AWS using Terraform. The module takes in variables to configure the deployment, including the IP address you will connect from, the AWS VPC details, and other necessary configuration details.

## Prerequisites

* Terraform >= 0.14
* AWS account and AWS CLI credentials with appropriate permissions

## Usage

To use this module, include the following code in your Terraform project:

```terraform
module "boundary_server" {
  source = "github.com/example/repo-name"

  my_ip              = "x.x.x.x/32"
  ssh_sg             = "ssh-security-group-id"
  vpc_id             = "vpc-id"
  region             = "us-west-2"
  public_subnet_ids  = ["subnet-id-1", "subnet-id-2"]
  private_subnet_ids = ["subnet-id-3", "subnet-id-4"]
  management_key     = "management-key-name"
  vpc_cidr           = "vpc-cidr-block"
}
```

Replace `example/repo-name` with the actual repository name where this module is hosted.

## Inputs

This module requires the following inputs:
| Name               | Description                                                          | Type           | Required |
| ------------------ | -------------------------------------------------------------------- | -------------- | -------- |
| my_ip              | IP address you connect from (e.g. x.x.x.x/32)                        | `string`       | yes      |
| ssh_sg             | ID of the SSH security group                                         | `string`       | yes      |
| vpc_id             | ID of the VPC where the server will be deployed                      | `string`       | yes      |
| region             | AWS region where the server will be deployed                         | `string`       | yes      |
| public_subnet_ids  | List of IDs of the public subnets where the server will be deployed  | `list(string)` | yes      |
| private_subnet_ids | List of IDs of the private subnets where the server will be deployed | `list(string)` | yes      |
| management_key     | Name of the key pair used for server management                      | `string`       | yes      |
| vpc_cidr           | CIDR block of the VPC                                                | `string`       | yes      |

## Outputs

This module provides the following outputs:
| Name                      | Description                                                   |
| ------------------------- | ------------------------------------------------------------- |
| boundary_endpoint         | URL of the Boundary server                                    |
| boundary_auth_method_id   | ID of the authentication method used by the Boundary server   |
| boundary_auth_method_type | Type of the authentication method used by the Boundary server |

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.

## Authors

Dan Fedick