#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

sudo a2enmod ssl
sudo apt-get -y install libapache2-mod-fastcgi php-apcu
sudo a2enmod actions fastcgi vhost_alias
sudo chown vagrant: /var/lib/apache2/fastcgi
sudo service apache2 restart