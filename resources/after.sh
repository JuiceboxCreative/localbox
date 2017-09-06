#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

sudo a2enmod ssl
sudo apt-get -y install libapache2-mod-fastcgi php-apcu
sudo a2enmod actions fastcgi vhost_alias
sudo chown vagrant: /var/lib/apache2/fastcgi
sudo service apache2 restart
sudo apt-get -y install zsh
echo "vagrant" | chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sudo apt-get install cachefilesd
sudo chown vagrant: /etc/default/cachefilesd
echo "RUN=yes" > /etc/default/cachefilesd
git config --global core.preloadindex true
git config --global core.filemode false
replace "plugins=(git)" "plugins=(composer laravel5 rsync vagrant yarn wp-cli)" -- ~/.zshrc
replace '# DISABLE_UNTRACKED_FILES_DIRTY="true"' 'DISABLE_UNTRACKED_FILES_DIRTY="true"' -- ~/.zshrc
echo "DEFAULT_USER=vagrant" >> ~/.zshrc
cd ~/
wget -q https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64
sudo mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail
sudo chmod +x /usr/local/bin/mhsendmail
sudo replace ";sendmail_path =" "sendmail_path = /usr/local/bin/mhsendmail" -- /etc/php/7.1/fpm/php.ini
sudo replace ";sendmail_path =" "sendmail_path = /usr/local/bin/mhsendmail" -- /etc/php/7.0/fpm/php.ini
sudo replace ";sendmail_path =" "sendmail_path = /usr/local/bin/mhsendmail" -- /etc/php/5.6/fpm/php.ini
sudo service php7.1-fpm restart
sudo service php7.0-fpm restart
sudo service php5.6-fpm restart
