# Kingdom Terraform
This repo allows me to spin up my tech on AWS without having to waste a bunch of time mucking about in the aws.amazon.com online UI thing.


## Usage

Before you can get started, you need to hop up to the cloud (aws.amazon.com) and create an iam user and give it permissions to do the things you want terraform to do (I just gave my user Administrative Access so I don't need to update it again).

###### Required ENV Variables:

(.bashrc or w/e loads when your console loads)
```
# My personal AWS keys
export HOBBY_AWS_ACCESS_KEY_ID='<insert from amazon>'
export HOBBY_AWS_SECRET_ACCESS_KEY='<insert from amazon>'

# If you don't own a domain name, don't worry, just set this env to any domain name and
# use /etc/hosts to redirect this to your elastic IP (EIP) after it's created
export TF_VAR_personal_site_domain='your-domain-name.com'
```

###### Required SSH Configs

To ssh into the resulting server, we'll need a `./ssh/config` that enables our admin access:
```
Host admin.your-domain-name.com
HostName admin.your-domain-name.com
User admin
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
LogLevel QUIET
IdentityFile ~/dev/hobby/kingdom_terraform/keys/personal-aws_rsa
IdentitiesOnly=yes
```
Alternatively, if you have a list of key's that you'd like granted admin access for this server, place them in `keys/authorized_keys`.  These keys will also have access to the dokku user of this machine.  If you go this route, obviously you'll need to adjust the `IdentityFile` directive to point to the appropriate key.

###### Usage Commands
There's a `deploy` file that provides various commands for working with this repo.  It's basically a wrapper around terraform that allows you to specify what environment to run things against.  The first time you run deploy, it will prompt you that it can't find the `keys` folder and ask if you'd like to create the stuff needed to work with this demo.  Choose yes and let it works it's magic.

```
# First you need to create the static infrastructure that you don't want spun up and down along with your EC2 and app related infrastructure.
# Think of this kind of infrastructure as the 'master' infrastructure that you'd like to be persistent (and backed up ideally)
$ cd static_infrastructure
$ ./deploy prd apply
$ cd ..

# Run this command to test the config file and see what terraform will do if
# it's actually activiated.
$ ./deploy prd plan

# Run this command to actually activate terraform and have it apply your
# infrastructure to the cloud.
$  ./deploy prd apply

# Run this command to destory all the infrastructure.  It's set to target just
# the EC2 instance though.
$ ./deploy prd destory
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
- Mount an S3 bucket as a folder (hint: the keys/ folder and the .tfstate folder):  http://www.skybert.net/linux/mounting-amazon-s3-buckets-on-debian/
- Mail https://www.chrisanthropic.com/sending-mail-ses-route53-dkim-spf-dmarc/
