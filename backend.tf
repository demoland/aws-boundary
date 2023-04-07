terraform {
  required_version = "~> 1.4.4"
  backend "remote" {
    organization = "demo-land"
    workspaces {
      name = "aws-boundary"
    }
  }
}
