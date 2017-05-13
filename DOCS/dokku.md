# Dokku

Dokku is a self-hosted, push-to-deploy, platform-as-a-service (PaaS) bash system that allows web developers the ease of deployment that heroku provides, without any extrodinary scalability or cost.  This terraform repo is configured to setup a base debian AMI with dokku so that you will be able to spin up a platform in the `make apply` step, and then thereafter deploy an app onto the server with a simple `git push production master` command, just like how heroku works (but all thrifty-like).

###### Overview

1. Install dokku plugins like mysql on the dokku server
1. Push the app
1. Profit


## Required Setup

You need this alias on your local dev machine so you can talk to the server:

(`.bashrc`)
```
alias dokku-personal='ssh -t dokku@dokku.personal.dev'
```

You'll need this ssh_config entry so you can network with the dokku shell correctly:

(`.ssh/config`)
```
Host dokku.personal.dev
HostName personal.dev
User admin
#below is somewhat unsecure, but that's life
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
LogLevel QUIET
IdentityFile ~/dev/hobby/kingdom_terraform/keys/default-dokku_rsa
IdentitiesOnly=yes
```


## Deploying Your App

1. Look over the steps it took for terraform to install this thing (TODO:  link to provision script section)
1.


