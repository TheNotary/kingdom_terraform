# this file automatically loaded due to it's name terraform.tfvars

# Sometimes this syntax doesn't work in this file due to #uberhashicorpfail and you switch to below...
#variable "ubuntu_amis" {
#  type = "map"
#  default = {
#    "us-east-1" = "ami-cb4b94dd"
#    "us-west-1" = "ami-9899c7f8"
#  }
#}


#ubuntu_amis = { "us-east-1": "ami-cb4b94dd", "us-west-1": "ami-9899c7f8" }
ubuntu_amis = {
  "us-east-1" = "ami-cb4b94dd",
  "us-west-1" = "ami-9899c7f8"
}

#variable "ami" {
#  default = "ami-9899c7f8"
#}

ami = "ami-9899c7f8"

key_path = "/home/john/dev/hobby/kingdom_terraform/keys/personal-aws_rsa.pub"
