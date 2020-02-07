provider "aws" {
  region = "ca-central-1"
}

module "instance" {
  source = "./instance"
  
}
