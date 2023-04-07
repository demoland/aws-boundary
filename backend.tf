terraform {
  cloud {
    organization = "demo-land"

    workspaces {
      name = "aws-boundary"
    }
  }
}
