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
debian_amis = {
  "us-east-1" = "ami-cb4b94dd",
  "us-west-1" = "ami-9899c7f8"
}

#variable "ami" {
#  default = "ami-9899c7f8"
#}

#region = "us-west-1"
ami = "ami-9899c7f8"

pub_key_path = "keys/personal-aws_rsa.pub"
priv_key_path = "keys/personal-aws_rsa"


# You can set your domain name to your personal site here or via the env
# variable TF_VAR_personal_site_domain
#personal_site_domain = "personal.dev"
#route53_zone_id = "Z0MOAIXZNRKW9W"
