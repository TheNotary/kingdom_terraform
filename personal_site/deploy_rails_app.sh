#!/usr/bin/env bash
the_hostname=$1
mail_server=$2
smtp_user=$3
smtp_pass=$4
aws_region=$5
aws_id=$6
aws_secret=$7
aws_bucket=$8

cat >/home/admin/scripts/deploy_params << EOF
the_hostname=$1
mail_server=$2
smtp_user=$3
smtp_pass=$4
aws_region=$5
aws_id=$6
aws_secret=$7
aws_bucket=$8

app_name=eff_fab
EOF


cd /home/admin
mkdir dev && cd dev

git clone https://github.com/TheNotary/eff_fab.git
cd eff_fab

app_name=eff_fab

git remote add dokku dokku:/${app_name}
dokku apps:create ${app_name}
dokku create ${app_name}

# # Configure SSL
# dokku config:set --no-restart ${app_name} DOKKU_LETSENCRYPT_EMAIL=your@email.tld
# dokku letsencrypt ${app_name}

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
  domain_name="${the_hostname}" \
  mail_server="${mail_server}" \
  mail_port="587" \
  mail_authentication="login" \
  mail_enable_starttls_auto="true" \
  mail_user_name="${smtp_user}" \
  mail_password="${smtp_pass}" \
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

dokku run ${app_name} rake db:migrate user:populate_users || true # the 'or true' allows this task to fail, without interupting the spin up of the EC2 instance.

