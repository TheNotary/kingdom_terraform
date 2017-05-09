

plan:
	terraform plan \
  -var 'access_key=${HOBBY_AWS_ACCESS_KEY_ID}' \
  -var 'secret_key=${HOBBY_AWS_SECRET_ACCESS_KEY}'


  #-var-file=blah -state=blah -target=aws_instance.www-alpha


.PHONY: deploy-stage
