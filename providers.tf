
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.0"
    }
  }
}

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      Owner       = "Daniel Fedick"
      Purpose     = "DEMOLAND"
      Terraform   = true
      Environment = "development"
      DoNotDelete = true
      Name        = "DEMOLAND BOUNDARY"
    }
  }

}
