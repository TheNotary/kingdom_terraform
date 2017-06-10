#!/usr/bin/env bash
the_hostname=$1
mail_server=$2
smtp_user=$3
smtp_pass=$4
aws_region=$5
aws_id=$6
aws_secret=$7
aws_bucket=$8
app_name=eff-fab

# For debugging
cat >/home/admin/scripts/deploy_params << EOF
the_hostname=$1
mail_server=$2
smtp_user=$3
smtp_pass=$4
aws_region=$5
aws_id=$6
aws_secret=$7
aws_bucket=$8

app_name=eff-fab
EOF

# Dependencies
source /home/admin/scripts/cert_restoration_helpers.sh


# Clone app to be deployed and prepare for deployment
cd /home/admin
mkdir dev && cd dev
git clone https://github.com/TheNotary/eff_fab.git
cd eff_fab

git remote add dokku dokku:/${app_name}
dokku apps:create ${app_name}


# Setup Configs Required for App
dokku config:set ${app_name} \
  secret_key_base="$(xxd -l "64" -p /dev/urandom | tr -d " \n" ; echo)" \
  fab_starting_day="Monday" \
  fab_due_time="5:00pm" \
  time_zone="Pacific Time (US & Canada)" \
  admin_name="John Doe" \
  admin_email="admin@${the_hostname}" \
  admin_password="CHANGE_ME_$(xxd -l "4" -p /dev/urandom | tr -d " \n" ; echo)" \
  cache_store="memory_store" \
  MEMCACHIER_SERVERS="" \
  MEMCACHIER_USERNAME="" \
  MEMCACHIER_PASSWORD="" \
  domain_name="${app_name}.${the_hostname}" \
  mail_from_domain="us-west-2.amazonses.com" \
  mail_server="${mail_server}" \
  mail_fab_sender_address="admin@${the_hostname}" \
  mail_port="587" \
  mail_authentication="login" \
  mail_user_name="${smtp_user}" \
  mail_password="${smtp_pass}" \
  mail_link_protocol="http" \
  mail_enable_starttls_auto="true" \
  mail_delivery_method="smtp" \
  storage="s3" \
  amazon_access_key_id="${aws_id}" \
  amazon_secret_access_key="${aws_secret}" \
  amazon_region="${aws_region}" \
  amazon_bucket_name="${aws_bucket}"


# Setup DB for App
dokku apps:create ${app_name}
dokku config:set ${app_name} MYSQL_DATABASE_SCHEME=mysql2
dokku mysql:create ${app_name}_db
dokku mysql:link ${app_name}_db ${app_name}

dokku checks:skip ${app_name} # allow the initial deploy to be accepted, even though the database isn't online yet
git push dokku develop:master ||
  git push dokku develop:master # It works the second time, but not the first... can't seem to read the ENV variables during the assets:precompile phase...
dokku checks:enable ${app_name}


# Configure TLS
_restoreCert ${app_name}
dokku config:set --no-restart ${app_name} DOKKU_LETSENCRYPT_EMAIL=admin@${the_hostname}
dokku letsencrypt ${app_name}
_backupCert


# Complete the application deployment
#dokku config:set ${app_name} force_ssl="true"
dokku run ${app_name} rake db:migrate user:populate_users || true # the 'or true' allows this task to fail, without interupting the spin up of the EC2 instance.
