# Dokku

Dokku is a self-hosted, push-to-deploy, platform-as-a-service (PaaS) bash system that allows web developers the ease of deployment that heroku provides, without any extrodinary scalability or cost.  Dokku is a container bases solution, so if you're excited about docker and rkt, you'll be quite excited about this... sort of... docker framework for building pipelines for modern applications.  This terraform repo is configured to setup a base debian AMI with dokku so that you will be able to spin up a platform in the `make apply` step, and then thereafter deploy an app onto the server with a simple `git push production master` command, just like how heroku works (but all thrifty-like).

###### Overview

1. Install dokku plugins like mysql on the dokku server
1. Push your app (eg `git push dokku-personal master`)
1. Create a database container and a database for you app and link your app with the database container
1. Navigate to your app... it's on the web!!!  On AWS!!!  You can have a dozen apps deployed like this at no extra charge!!!



## Required Setup

### Local (dev) machine
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

### Dokku Server

Install postgres plugin.  You'll need to ssh directly onto the machine w/ a sudo-ish account like admin.

```
$  ssh private.dev
$  sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git
```


## Deploying Your App

The first step is to simply `git push` our app up to the dokku user.  When we do this, the server will recieve the git repo and create the app for us and begin the deploy process.  The first time we push the app, it won't work unless it doesn't use a database for some reason.

```
$  cd /path/to/app_name
$  git remote add dokku-personal dokku.personal.dev:/app_name
... Lots of mostly happy output ...
```

Next, I want you to, just look over the steps it took for terraform to install this thing (TODO:  link to provision script section).  There's a bit at the bottom where a postgresql plugin is installed.  Thats what enables our dokku server the ability to create database containers with which our app can store persistant data.  We need to run a couple follow up commands to put our database right for our app.

```
dokku-personal postgres:create stock_chart_db
dokku-personal postgres:link stock_chart_db stock_chart

# Migrate your apps Database
dokku-personal run stock_chart rake db:migrate
```


