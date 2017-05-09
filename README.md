# Kingdom Terraform
This repo allows me to spin up my tech on AWS without having to waste a bunch of time mucking about in the aws.amazon.com online UI thing.


## Usage

Required ENV Variables:

(.bashrc or w/e loads when your console loads)
```
# My personal AWS keys
export HOBBY_AWS_ACCESS_KEY_ID='<insert from amazon>'
export HOBBY_AWS_SECRET_ACCESS_KEY='<insert from amazon>'
```

There's a `Makefile` that set's up the command `make plan`.  By this mechanism, variables can be set in a somewhat simple way.  Not sure if I'll use `make plan` or `terraform plan` in the future though.


## Notes

- To choose the AMI, you need to search for a debian box in the desired region:  http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html


## References

- The starter project: http://grange74.github.io/blog/2015/05/20/terraform-hello-world-on-aws/
- Variabls and how they are annoying:  https://www.terraform.io/intro/getting-started/variables.html
