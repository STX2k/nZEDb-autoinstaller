#!/bin/bash
# Script Name: nZEDb Auto Installer
# Author: STX2k (2016)
# Based on the idea from: PREngineer
# IMPORTANT: RUN THIS SCRIPT FIRST!
#############################################

# Color definition variables
YELLOW='\e[33;3m'
RED='\e[91m'
BLACK='\033[0m'
CYAN='\e[96m'
GREEN='\e[92m'

# Variables


# Make sure to clear the Terminal
clear


# Display the Title Information
echo
echo -e $RED
echo -e '  ________________________  ___________  __    '
echo -e ' /   _____/\__    ___/\   \/  /\_____  \|  | __'
echo -e ' \_____  \   |    |    \     /  /  ____/|  |/ /'
echo -e ' /        \  |    |    /     \ /       \|    < '
echo -e '/_______  /  |____|   /___/\  \\_______ \__|_ \'
echo -e '        \/                  \_/        \/    \/'


echo -e $CYAN
echo -e 'nZEDb Auto Installer by STX2k'
echo


echo -e $RED' You use this Script on your own risk!'$BLACK
echo

# Function to check if running user is root
function CHECK_ROOT {
	if [ '$(id -u)' != '0' ]; then
		echo
		echo -e $RED 'This script must be run as root.' 1>&2
		echo
		exit 1
	fi
}

#User for nZEDb
echo -e $YELLOW
echo -e '---> [For safety reasons, we create a separate user...]'$BLACK
read -p 'User Account Name (eg.'nzedb'):' usernamenzb
sudo useradd -r -s /bin/false $usernamenzb
sudo usermod -aG www-data $usernamenzb
echo -e $GREEN
echo -e 'DONE!'

# Updating System
echo -e $YELLOW
echo -e '---> [Updating System...]'$BLACK
sudo apt-get update > /dev/null
sudo apt-get -y upgrade > /dev/null
sudo apt-get -y dist-upgrade > /dev/null
echo -e $GREEN
echo -e 'DONE!'

# Installing Basic Software
echo -e $YELLOW
echo -e '---> [Installing Basic Software...]'$BLACK
sudo apt-get install -y nano curl git htop man software-properties-common par2 unzip wget tmux ntp ntpdate time tcptrack bwm-ng mytop > /dev/null
sudo python3 -m easy_install pip > /dev/null
echo -e $GREEN
echo -e 'DONE!'

# Installing Extra Software like mediainfo
echo -e $YELLOW
echo -e '---> [Install ffmpeg, mediainfo, p7zip-full, unrar and lame...]'$BLACK
sudo apt-get install -y unrar p7zip-full mediainfo lame ffmpeg libav-tools > /dev/null
echo -e $GREEN
echo -e 'DONE!'

# Installing Python 3 and some modules
echo -e $YELLOW
echo -e '---> [Installing Python 3 and Modules...]'$BLACK
sudo apt-get install -y python-setuptools software-properties-common python3-setuptools python3-pip python-pip && \
python -m easy_install pip  && \
easy_install cymysql && \
easy_install pynntp && \
easy_install socketpool && \
pip list && \
python3 -m easy_install pip && \
pip3 install cymysql && \
pip3 install pynntp && \
pip3 install socketpool && \
pip3 list > /dev/null
echo -e $GREEN
echo -e 'DONE!'

# Installing yEnc - Needed for nzb Headers
echo -e $YELLOW
echo -e '---> [Install yEnc from source...]'$BLACK
cd ~
mkdir yenc
cd yenc
wget http://heanet.dl.sourceforge.net/project/yydecode/yydecode/0.2.10/yydecode-0.2.10.tar.gz
tar xzf yydecode-0.2.10.tar.gz
cd yydecode-0.2.10
./configure
make
sudo make install
cd ../..
rm -rf ~/yenc
echo -e $GREEN
echo -e 'DONE!'

# Installing Composer for nZEDb
echo -e $YELLOW
echo -e '---> [Install Composer...]'$BLACK
php -r 'copy('https://getcomposer.org/installer', 'composer-setup.php');' > /dev/null
php -r 'if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;' > /dev/null
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer > /dev/null
php -r 'unlink('composer-setup.php');' > /dev/null
composer -V
echo -e $GREEN
echo -e 'DONE!'

#Add PHP 5.6 ppa:ondrej/php
echo -e $YELLOW
echo -e '---> [Add PHP 5.6 Repo...]'
echo -e 'You must press -> Enter <- to confirm'$BLACK
sudo add-apt-repository ppa:ondrej/php
echo -e $GREEN
echo -e 'DONE!'

# Installing PHP5.6
echo -e $YELLOW
echo -e '---> [Installing PHP & Extensions...]'$BLACK
sudo apt-get install -y libpcre3-dev php5.6 php5.6-dev php-pear php5.6-gd php5.6-mysqlnd php5.6-curl php5.6-mcrypt > /dev/null
echo -e $GREEN
echo -e 'DONE!'

# Configure PHP 5.6
echo -e $YELLOW
echo -e '---> [Do some magic with the php5.6 config...]'$BLACK
sed -ri 's/(max_execution_time =) ([0-9]+)/\1 120/' /etc/php5/cli/php.ini
sed -ri 's/(memory_limit =) ([0-9]+)/\1 -1/' /etc/php5/cli/php.ini
sed -ri 's/(upload_max_filesize =) ([0-9]+)/\1 100/' /etc/php5/cli/php.ini
sed -ri 's/(post_max_size =) ([0-9]+)/\1 150/' /etc/php5/cli/php.ini
sed -ri 's/;(date.timezone =)/\1 Europe\/Berlin/' /etc/php5/cli/php.ini
sed -ri 's/(max_execution_time =) ([0-9]+)/\1 120/' /etc/php5/fpm/php.ini
sed -ri 's/(memory_limit =) ([0-9]+)/\1 1024/' /etc/php5/fpm/php.ini
sed -ri 's/(upload_max_filesize =) ([0-9]+)/\1 100/' /etc/php5/fpm/php.ini
sed -ri 's/(post_max_size =) ([0-9]+)/\1 150/' /etc/php5/fpm/php.ini
sed -ri 's/;(date.timezone =)/\1 Europe\/Berlin/' /etc/php5/fpm/php.ini
echo -e $GREEN
echo -e 'DONE!'

# Install yEnc decoder extension for PHP5
echo -e $YELLOW
echo -e '---> [Install yEnc decoder extension for PHP5...]'$BLACK
cd /tmp && \
 git clone https://github.com/kevinlekiller/simple_php_yenc_decode && \
 cd simple_php_yenc_decode/ && \
 sh ubuntu.sh && \
 cd ~ && \
 rm -rf /tmp/simple_php_yenc_decode/
echo -e $GREEN
echo -e 'DONE!'

# Installing MYSQL 5.6
echo -e $YELLOW
echo -e '---> [Installing MySQL...]'$BLACK
sudo apt-get install -y mysql-server-5.6 mysql-client-5.6
echo -e $GREEN
echo -e 'DONE!'

# Creating MySQl User for nZEDb
echo -e $YELLOW
echo -e '---> [Set password for MySQL user 'nzedb'...]'$BLACK
read -p 'Set password:' passwordmysql
echo -e $CYAN
echo -e '---> [Creating MySQL user 'nzedb'...]'$BLACK
echo -e $RED 'Please login with your MySQL Root password!'
MYSQL=`which mysql`
Q0='CREATE USER 'nzedb'@'%' IDENTIFIED BY '$passwordmysql';'
Q1='GRANT ALL ON *.* TO 'nzedb'@'%' IDENTIFIED BY '$passwordmysql';'
Q2='GRANT FILE ON *.* TO 'nzedb'@'%' IDENTIFIED BY '$passwordmysql';'
Q3='FLUSH PRIVILEGES;'
SQL='${Q0}${Q1}${Q2}${Q3}'
$MYSQL -uroot -p -e '$SQL'
echo
echo -e '-------------------------------------------------'
echo -e '# WHEN FILLING THE DATABASE INFORMATION IN NZEDB#'
echo -e '# USE '0.0.0.0' as the hostname!                #'
echo -e '#                                               #'
echo -e '# MySQL User: nzedb                             #'
echo -e '# MySQL Pass: $passwordmysql                    #'
echo -e '#                                               #'
echo -e '# Safe this login details for install nzedb     #'
echo -e '-------------------------------------------------'$BLACK
echo -e $YELLOW
echo -e '---> [Lets secure the MySQL installation...]'$BLACK
mysql_secure_installation
echo -e $GREEN
echo -e 'DONE!'

# Install Apache 2.4
echo -e $YELLOW
echo -e '---> [Installing Apache 2...]'$BLACK
sudo apt-get install -y apache2 libapache2-mod-php5.6 > /dev/null
sudo echo '<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName localhost
    DocumentRoot '/var/www/nZEDb/www'
    LogLevel warn
    ServerSignature Off
    ErrorLog /var/log/apache2/error.log
    <Directory '/var/www/nZEDb/www'>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    Alias /covers /var/www/nZEDb/resources/covers
</VirtualHost>' > nZEDb.conf
sudo mv nZEDb.conf /etc/apache2/sites-available/
echo -e $CYAN
read -p 'Set Servername (eg. yourindex.com):' servername
sed -i 's/\blocalhost\b/$servername/g' /etc/apache2/sites-available/nZEDb.conf
echo -e $CYAN
echo -e '---> [Disable Apache 2 default site...]'$BLACK
sudo a2dissite 000-default
echo -e $CYAN
echo -e '---> [Enable nZEDb site config...]'$BLACK
sudo a2ensite nZEDb.conf
echo -e $CYAN
echo -e '---> [Enable ModRewite...]'$BLACK
sudo a2enmod rewrite
echo -e $CYAN
echo -e '---> [Restart Apache 2...]'$BLACK
sudo service apache2 restart
echo -e $GREEN
echo -e 'DONE!'

# Install memcached
echo -e $YELLOW
echo -e '---> [Installing memcached...]'$BLACK
sudo apt-get install -y memcached php5.6-memcached > /dev/null
echo -e $GREEN
echo -e 'DONE!'

# Install nZEDb
echo -e $YELLOW
echo -e '---> [nZEDb install...]'$BLACK
cd /var/www
composer create-project --no-dev --keep-vcs --prefer-source nzedb/nzedb nzedb
echo -e $GREEN
echo -e 'DONE!'

# Fixing Permissions
echo -e $YELLOW
echo -e '---> [nZEDb install...]'$BLACK
sudo chmod -R 755 /var/www/nZEDb/app/libraries
sudo chmod -R 755 /var/www/nZEDb/libraries
sudo chmod -R 777 /var/www/nZEDb/resources
sudo chmod -R 777 /var/www/nZEDb/www
sudo chgrp www-data nzedb
sudo chmod -R 777 /var/www/nzedb
sudo chgrp www-data /var/www/nzedb/resources/smarty/templates_c
sudo chgrp -R www-data /var/www/nzedb/resources/covers
sudo chgrp www-data /var/www/nzedb/www
sudo chgrp www-data /var/www/nzedb/www/install
sudo chgrp -R www-data /var/www/nzedb/resources/nzb
sudo chown -R www-data:www-data /var/lib/php/sessions/
echo -e $GREEN
echo -e 'DONE!'

# Complete the Web Setup!

echo -e $RED'STOP! WARING! STOP! WARNING! STOP! WARNING!'$BLACK
echo -e $RED'STOP! WARING! STOP! WARNING! STOP! WARNING!'$BLACK

echo -e $YELLOW
echo -e '-------------------------------------------------'
echo -e '# You must complete the install of nzedb first  #'
echo -e '# Go to http://yourdomain.com/install           #'
echo -e '#                                               #'
echo -e '# After the nzedb Setup is finish you can       #'
echo -e '# continue the Setup Script! OK?                #'
echo -e '-------------------------------------------------'$BLACK

echo -e $RED'STOP! WARING! STOP! WARNING! STOP! WARNING!'$BLACK
echo -e $RED'STOP! WARING! STOP! WARNING! STOP! WARNING!'$BLACK


read -p 'Press [Enter] to continue...'

# PreDB Dump
echo -e $YELLOW
echo -e '---> [Importing Initial PreDB Dump...]'$BLACK
sudo wget https://www.dropbox.com/s/qkmgbvmdv9a5w8q/predb_dump_08172015.tar.gz
sudo gunzip predb_dump_08172015.tar.gz
sudo tar -xvf predb_dump_08172015.tar
echo
echo -e $RED'PLEASE BE PATIENT!  THIS   + W I L L +   TAKE A LONG TIME!'$BLACK
echo
sudo php /var/www/nzedb/misc/testing/PreDB/dump_predb.php remote tmp/predb_dump_08172015.csv
echo -e $GREEN
echo -e 'DONE!'

# Import Daily Dumps
echo -e $YELLOW
echo -e '---> [Importing Daily Dumps...]'$BLACK
sudo chmod 777 /var/www/nzedb/resources
sudo chown -R $usernamenzb:www-data /var/www/nzedb/cli
echo
echo -e $RED'PLEASE BE PATIENT!  THIS   + M A Y +   TAKE A LONG TIME!'$BLACK
echo
sudo php /var/www/nzedb/cli/data/predb_import_daily_batch.php 0 remote true
echo -e $GREEN
echo -e 'DONE!'

# Fixing Install TMUX
echo -e $YELLOW
echo -e '---> [Installing TMUX...]'$BLACK
sudo apt-get install -y tmux time python-setuptools python-pip python3-setuptools python3-pip > /dev/null
sudo easy_install cymysql pynntp socketpool
sudo pip3 install cymysql pynntp socketpool
echo -e $GREEN
echo -e 'DONE!'

echo -e $YELLOW
echo -e '---> [Configuring TMUX To Run On Startup...]'$BLACK
(crontab -l 2>/dev/null; echo '@reboot /bin/sleep 10; /usr/bin/php /var/www/nzedb/misc/update/nix/tmux/start.php') | crontab -
echo -e $GREEN
echo -e 'DONE!'

echo -e $GREEN
echo -e '---> WE ARE DONE!'$BLACK
echo -e 'To manually index run the files located in $BLUE misc/update_scripts'$BLACK
echo -e 'update_binaries = to GET article headers'
echo -e 'update_releases = to CREATE releases'
echo -e ''
echo -e 'To automate the process use the script located in $BLUE misc/update_scripts/nix_scripts'$BLACK

read -p 'Press [Enter] to continue...'

echo -e $YELLOW
echo -e '---> [Rebooting...]'$BLACK
sudo reboot now
echo -e $GREEN
echo -e 'DONE!'$BLACK
