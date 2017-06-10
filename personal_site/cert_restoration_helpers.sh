#!/usr/bin/env bash

function _backupAllCerts {
  FOLDERS=/home/dokku/*
  for folder_path in $FOLDERS
  do
    if [ -d "${folder_path}" ]; then
      folder_name=$(basename ${folder_path})
      echo "Found folder named ${folder_name} file..."
      # take action on each file. $f store current file name
      [ -d "${folder_path}/letsencrypt" ] &&
        mkdir -p /mnt/persistent/certs/${folder_name} &&
        cp -r ${folder_path}/letsencrypt /mnt/persistent/certs/${folder_name}
    fi
  done
}

function _restoreAllCerts {
  FOLDERS=/mnt/persistent/certs/*
  for folder_path in $FOLDERS
  do
    if [ -d "${folder_path}/letsencrypt" ]; then
      folder_name=$(basename ${folder_path})
      echo "going to write to /home/dokku/${folder_name}"
      [ -d "/home/dokku/${folder_name}" ] &&
        sudo mkdir -p /home/dokku/${folder_name}/letsencrypt &&
        sudo cp -r ${folder_path}/letsencrypt /home/dokku/${folder_name} &&
        sudo chown -R dokku /home/dokku/${folder_name}/letsencrypt
    fi
  done
}

# This function will check /mnt/persistent/certs for backups of a cert for
# the app specified, and install it into the dokku app folder
function _backupCert {
  [ -z "$1" ] && echo "please specify an app_name" && return 1
  app_name=$1
  backup_path="/mnt/persistent/certs/${app_name}"

  if [ -d "/home/dokku/${app_name}/letsencrypt" ]; then
    sudo mkdir -p ${backup_path}
    sudo cp -r /home/dokku/${app_name}/letsencrypt ${backup_path}
  else
    echo "App certs not found, nothing to backup for: ${app_name}."
    return 1
  fi
}

# This function will check /mnt/persistent/certs for backups of a cert for
# the app specified, and install it into the dokku app folder
function _restoreCert {
  [ -z "$1" ] && echo "please specify an app_name" && return 1
  app_name=$1
  backup_path="/mnt/persistent/certs/${app_name}"

  if [ -d "/home/dokku/${app_name}" ]; then
    if [ -d "/mnt/persistent/certs/${app_name}" ]; then
      sudo mkdir -p /home/dokku/${app_name}/letsencrypt
      sudo cp -r ${backup_path}/letsencrypt /home/dokku/${app_name}
      sudo chown -R dokku /home/dokku/${app_name}
    else
      echo "No certs found for app: ${app_name}."
      return 0
    fi
  else
    echo "App not found: ${app_name}."
    return 1
  fi
}
