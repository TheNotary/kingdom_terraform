provider "aws" {
    access_key = "ABC123"
    secret_key = "DEF456"
    region = "us-west-2"
}

resource "aws_instance" "web" {
    ami = "ami-5b9d1c3b"
    instance_type = "t2.nano"
    instance_id = "308192f3-3019-4299-873e-35b8434f9cd4"
}
