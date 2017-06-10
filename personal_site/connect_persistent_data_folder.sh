#!/usr/bin/env bash

aws_id=$1     # asdf
aws_secret=$2 # asdfas
aws_bucket=$3 # personal-site-data-prd
region=$4     # us-west-2


#################
# Connect to S3 #
#################

echo "${aws_id}:${aws_secret}" | sudo tee /etc/passwd-s3fs
sudo chmod 0600 /etc/passwd-s3fs

sudo mkdir /mnt/persistent
sudo chown admin /mnt/persistent
sudo s3fs ${aws_bucket}:/ /mnt/persistent -o endpoint=us-west-2 -o allow_other
