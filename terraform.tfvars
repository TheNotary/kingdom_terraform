# this file automatically loaded due to it's name terraform.tfvars

variable "amis" {
  type = "map"
  default = {
    "us-east-1" = "ami-cb4b94dd"
    "us-west-1" = "ami-9899c7f8"
  }
}

