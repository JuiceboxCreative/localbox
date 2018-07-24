#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

sudo apt-get -y install nfs-kernel-server
sudo chown vagrant: /var/lib/apache2/fastcgi
if [ -e /etc/apache2/sites-enabled/phpconfig.conf ]
then
    echo "Skipping fastcgi config, already exists"
else
    sudo touch /etc/apache2/sites-enabled/phpconfig.conf
    sudo chown vagrant: /etc/apache2/sites-enabled/phpconfig.conf
    sudo echo "<IfModule mod_fastcgi.c>" >> /etc/apache2/sites-enabled/phpconfig.conf
    sudo echo "FastCgiExternalServer /usr/lib/cgi-bin/php7.2 -socket /var/run/php/php7.2-fpm.sock -idle-timeout 300 -pass-header Authorization" >> /etc/apache2/sites-enabled/phpconfig.conf
    sudo echo "Alias /php72-fcgi /usr/lib/cgi-bin/php7.2" >> /etc/apache2/sites-enabled/phpconfig.conf
    sudo echo "Action php72-fcgi /php72-fcgi virtual" >> /etc/apache2/sites-enabled/phpconfig.conf
    sudo echo "FastCgiExternalServer /usr/lib/cgi-bin/php7.1 -socket /var/run/php/php7.1-fpm.sock -idle-timeout 300 -pass-header Authorization" >> /etc/apache2/sites-enabled/phpconfig.conf
    sudo echo "Alias /php71-fcgi /usr/lib/cgi-bin/php71-fcgi" >> /etc/apache2/sites-enabled/phpconfig.conf
    sudo echo "Action php71-fcgi /php71-fcgi virtual" >> /etc/apache2/sites-enabled/phpconfig.conf
    sudo echo "FastCgiExternalServer /usr/lib/cgi-bin/php7.0 -socket /var/run/php/php7.0-fpm.sock -idle-timeout 300 -pass-header Authorization" >> /etc/apache2/sites-enabled/phpconfig.conf
    sudo echo "Alias /php70-fcgi /usr/lib/cgi-bin/php7.0" >> /etc/apache2/sites-enabled/phpconfig.conf
    sudo echo "Action php70-fcgi /php70-fcgi virtual" >> /etc/apache2/sites-enabled/phpconfig.conf
    sudo echo "FastCgiExternalServer /usr/lib/cgi-bin/php5.6 -socket /var/run/php/php5.6-fpm.sock -idle-timeout 300 -pass-header Authorization" >> /etc/apache2/sites-enabled/phpconfig.conf
    sudo echo "Alias /php56-fcgi /usr/lib/cgi-bin/php5.6" >> /etc/apache2/sites-enabled/phpconfig.conf
    sudo echo "Action php56-fcgi /php56-fcgi virtual" >> /etc/apache2/sites-enabled/phpconfig.conf
    sudo echo "</IfModule>" >> /etc/apache2/sites-enabled/phpconfig.conf
fi

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
