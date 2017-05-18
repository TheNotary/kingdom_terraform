# Kingdom Terraform
This repo allows me to spin up my tech on AWS without having to waste a bunch of time mucking about in the aws.amazon.com online UI thing.


## Usage

Before you can get started, you need to hop up to the cloud (aws.amazon.com) and create an iam user and give it permissions to do the things you want terraform to do (I just gave my Administrative Access so I don't need to update it again).

###### Required ENV Variables:

(.bashrc or w/e loads when your console loads)
```
# My personal AWS keys
export HOBBY_AWS_ACCESS_KEY_ID='<insert from amazon>'
export HOBBY_AWS_SECRET_ACCESS_KEY='<insert from amazon>'
```

There's a `Makefile` that provides various commands for working with this repo.

```
# Run this command once to initialize all your keys for the first time.
$ make init

# Run this command to test the config file and see what terraform will do if
# it's actually activiated.
$ make plan

# Run this command to actually activate terraform and have it apply your
# infrastructure to the cloud.
$  make apply

# Run this command to destory all the infrastructure.  It's set to target just
# the EC2 instance though.
$ make destory
```


## Notes

To choose the AMI, you need to search for a debian box in the desired region:
  * http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html

You might need to login to the aws console and search the correct box just to sign an agreement, not sure.


# Next Steps

When you're all done here and have successfully created a personal_site server on the cloud (it won't look like much when you navigate there, so don't worry) you should head on to the [dokku docs](DOCS/dokku.md) to push an actual app to your dokku server to have it deployed.


## References

- The starter project: http://grange74.github.io/blog/2015/05/20/terraform-hello-world-on-aws/
- Variabls and how they are annoying:  https://www.terraform.io/intro/getting-started/variables.html
- use `terraform import aws_instance.web i-12345678` to go in reverse, take configs from amazon and build at `.tf` file from them!?!

