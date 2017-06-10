#!/usr/bin/env bash
box_hostname=$1

echo "about to use this as hostname:  ${box_hostname}"

printf "Personal Site Server!\nIf you spot a vuln, please leave a note here :)\n" | sudo tee /etc/motd > /dev/null
sudo apt-get update
sudo apt-get install -y vim fuse S3FS


##############
# Setup S3FS #
##############

# Uses fuse and S3FS packages
sudo ldconfig
sudo modprobe fuse


#################
# Add Swap file #
#################

# ref: http://stackoverflow.com/questions/17173972/how-do-you-add-swap-to-an-ec2-instance
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo /sbin/mkswap /var/swap.1
sudo chmod 600 /var/swap.1
sudo /sbin/swapon /var/swap.1

printf "swap\t/var/swap.1 swap\tdefaults\t0\t0" | sudo tee -a /etc/fstab


################
# Setup Mumble #
################

sudo debconf-set-selections <<EOF
mumble-server   mumble-server/password          password  mumblepair
mumble-server   mumble-server/use_capabilities  boolean   true
mumble-server   mumble-server/start_daemon      boolean   true
EOF


sudo apt-get install -y mumble-server

sudo sed -i s/serverpassword\=/serverpassword\=hacktheplanet/ /etc/mumble-server.ini
sudo sed -i s/users=100/users=30/ /etc/mumble-server.ini
sudo sed -i '/welcometext=/c\welcometext="<br>Welcome to the coms.<br>Be humble. <br>Be respectful.<br>Be excelent.<br>"' /etc/mumble-server.ini

sudo service mumble-server restart


###############
# Setup Dokku #
###############

echo "dokku dokku/web_config boolean false" | sudo debconf-set-selections
echo "dokku dokku/vhost_enable boolean true" | sudo debconf-set-selections
echo "dokku dokku/hostname string ${box_hostname}" | sudo debconf-set-selections
echo "dokku dokku/key_file string /home/admin/.ssh/default-dokku_rsa.pub" | sudo debconf-set-selections

wget https://raw.githubusercontent.com/dokku/dokku/v0.9.4/bootstrap.sh
sudo DOKKU_TAG=v0.9.4 bash bootstrap.sh


# Install the postgresql plugin for dokku
#sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres

# Install the mysql plugin for dokku
sudo dokku plugin:install https://github.com/dokku/dokku-mysql.git mysql

# Install lets encrypt plugin
sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git



###############
# Deploy Apps #
###############

# Make Server Homey
cd ~
git clone https://github.com/TheNotary/dotfiles
cd dotfiles
./make.sh
echo "bash_display_style=server" >> ~/.this_machine
