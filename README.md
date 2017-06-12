# Kingdom Terraform
This repo allows you to spin up some services in AWS without having to waste a bunch of time mucking about in the aws.amazon.com online UI thing.


## Usage

Before you can get started, you need to hop up to the cloud (aws.amazon.com) and create an iam user and give it permissions to do the things you want terraform to do (I just gave my user Administrative Access so I don't need to update it again).  Once you have your credentials generated, put them into your `~/.aws/credentials` config file as displayed below:

(~/.aws/credentials)
```
[default]
aws_secret_access_key = <Inserter from aws.amazon.com>
aws_access_key_id = <Inserter from aws.amazon.com>
```


###### Required ENV Variables:

You need these environment variables loaded into your environment before you can apply this repo's `.tf` files with terraform.

(.bashrc or w/e loads when your console loads)
```
# If you don't own a domain name, don't worry, just set this env to any domain name and
# use /etc/hosts to redirect this to your elastic IP (EIP) after it's created
export TF_VAR_personal_site_domain='your-domain-name.com'

# (optional) If you have multiple profiles in your ~/.aws/credentials file, specify which
# you'd like to use here.  If nothing is supplied, default will be used.
export TF_VAR_aws_profile="default"
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


###### Deploying the Super Infrastructure

This repo's purpose is to show you everything required to hoist an application into the cloud.  One of the great things about IaC is that you can periodically blow away all of your servers and start again from scratch, ensuring that any compormized systems on your network will not be able to harbor malware after the vulnerability is closed via software upgrades.  But many cloud projects will require persistent things, such as persistent nameservers to be online... if you were to bring nameservers down by destroying your aws_route53_zone for instnace, you would then need to updating your domain registrar's records to poing domain queries to the new nameservers.  So for that kind of persistent stuff we're calling `super-infrastructure`, you'll control that from within the `static_infrastructure/` folder.

To create your static infrastructure:
```
$ cd static_infrastructure/
$ ./deploy prd apply
$ cd ..
```

Great, if that command works, you'll now be able to create the ordinary infrastructure in the root folder of this repo.  The deploy script is discussed in greater detail below.


###### Usage Commands
For every set of `.tf` files in this project, there's a `deploy` script that provides various commands for working with terraform.  It's basically a wrapper around terraform that allows you to specify what environment to run things against and what operation to perform.  The first time you run deploy, it will prompt you that it can't find the `keys` folder and ask if you'd like to create the stuff needed to work with this demo.  Choose yes and let it work it's magic.

```
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
