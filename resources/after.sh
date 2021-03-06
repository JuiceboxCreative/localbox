#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.
#
# If you have user-specific configurations you would like
# to apply, you may also create user-customizations.sh,
# which will be run after this script.

sudo apt-get -y install nfs-kernel-server
sudo chown vagrant: /var/lib/apache2/fastcgi
sudo service apache2 restart
sudo apt-get install cachefilesd
sudo chown vagrant: /etc/default/cachefilesd
echo "RUN=yes" > /etc/default/cachefilesd
git config --global core.preloadindex true
git config --global core.filemode false
cd ~/
wget -q https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64
sudo mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail
sudo chmod +x /usr/local/bin/mhsendmail
sudo replace ";sendmail_path =" "sendmail_path = /usr/local/bin/mhsendmail" -- /etc/php/7.2/fpm/php.ini
sudo replace "short_open_tag = Off" "short_open_tag = On" -- /etc/php/7.2/fpm/php.ini
sudo replace "max_execution_time = 30" "max_execution_time = 90" -- /etc/php/7.2/fpm/php.ini
sudo replace "cgi.fix_pathinfo=0" "cgi.fix_pathinfo=1" -- /etc/php/7.2/fpm/php.ini
sudo replace ";sendmail_path =" "sendmail_path = /usr/local/bin/mhsendmail" -- /etc/php/7.1/fpm/php.ini
sudo replace "short_open_tag = Off" "short_open_tag = On" -- /etc/php/7.1/fpm/php.ini
sudo replace "max_execution_time = 30" "max_execution_time = 90" -- /etc/php/7.1/fpm/php.ini
sudo replace "cgi.fix_pathinfo=0" "cgi.fix_pathinfo=1" -- /etc/php/7.1/fpm/php.ini
sudo replace ";sendmail_path =" "sendmail_path = /usr/local/bin/mhsendmail" -- /etc/php/7.0/fpm/php.ini
sudo replace "short_open_tag = Off" "short_open_tag = On" -- /etc/php/7.0/fpm/php.ini
sudo replace "max_execution_time = 30" "max_execution_time = 90" -- /etc/php/7.0/fpm/php.ini
sudo replace "cgi.fix_pathinfo=0" "cgi.fix_pathinfo=1" -- /etc/php/7.0/fpm/php.ini
sudo replace ";sendmail_path =" "sendmail_path = /usr/local/bin/mhsendmail" -- /etc/php/5.6/fpm/php.ini
sudo replace "short_open_tag = Off" "short_open_tag = On" -- /etc/php/5.6/fpm/php.ini
sudo replace "max_execution_time = 30" "max_execution_time = 90" -- /etc/php/5.6/fpm/php.ini
sudo replace "cgi.fix_pathinfo=0" "cgi.fix_pathinfo=1" -- /etc/php/5.6/fpm/php.ini
sudo phpdismod xdebug && sudo phpdismod -s cli xdebug
sudo service php7.2-fpm restart
sudo service php7.1-fpm restart
sudo service php7.0-fpm restart
sudo service php5.6-fpm restart
