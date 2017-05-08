

deploy-stage:
	terraform plan -var-file=blah -state=blah -target=aws_instance.www-alpha

.PHONY: deploy-stage
