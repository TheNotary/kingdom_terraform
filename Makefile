# I think using s3 buckets for state might be better
#state_file=${PWD##*/}-state/terraform.tfstate

init:
	mkdir -p keys/ && \
  echo "# put your ~/.ssh/id_rsa.pub keys in here for your team" >> keys/default_authorized_keys && \
  ssh-keygen -t RSA -b 4096 -N '' -f `pwd`/keys/personal-aws_rsa && \
  ssh-keygen -t RSA -b 4096 -N '' -f `pwd`/keys/default-dokku_rsa

plan:
	@terraform plan \
  -var 'access_key=${HOBBY_AWS_ACCESS_KEY_ID}' \
  -var 'secret_key=${HOBBY_AWS_SECRET_ACCESS_KEY}'

  #-target=aws_instance.webishthing

  #-var-file=blah -state=blah -target=aws_instance.www-alpha

apply:
	@terraform apply \
  -var 'access_key=${HOBBY_AWS_ACCESS_KEY_ID}' \
  -var 'secret_key=${HOBBY_AWS_SECRET_ACCESS_KEY}'

plan_destroy:
	@terraform plan -destroy \
  -var 'access_key=${HOBBY_AWS_ACCESS_KEY_ID}' \
  -var 'secret_key=${HOBBY_AWS_SECRET_ACCESS_KEY}'

destroy:
	@terraform destroy \
  -var 'access_key=${HOBBY_AWS_ACCESS_KEY_ID}' \
  -var 'secret_key=${HOBBY_AWS_SECRET_ACCESS_KEY}'

  #-target=aws_instance.personal_site # this will only destory the EC2 instance part of things, not the other configs surrounding it

destroy_dns:
	@terraform destroy \
  -var 'access_key=${HOBBY_AWS_ACCESS_KEY_ID}' \
  -var 'secret_key=${HOBBY_AWS_SECRET_ACCESS_KEY}'

  #-target=aws_route53_zone.personal_site

.PHONY: *
