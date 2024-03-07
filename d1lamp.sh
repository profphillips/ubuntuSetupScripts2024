#!/bin/bash

# d1lamp.sh developed by John Phillips 20160904 and updated 20240307
# This version is for Ubuntu Server 22.04 running on Virtual Box or AWS
# Configures a basic LAMP server using Apache 2, MySQL, PHP8.1, Perl and Python3.
# Creates a test user and several test scripts.

starttime=$(date "+%s")
newusername='jdoe'
userpw='mypw'
hostname='localhost'

# Function to display a separator line
print_separator() {
	echo '-----------------------------------------------------------------------------------------------'
}

# Function to update the system
update_system() {
	print_separator
	echo '---- UPDATING THE SERVER'
	apt-get -qq update -y
	apt-get -qq upgrade -y
	print_separator
}

# Function to set the hostname
set_hostname() {
	# local hostname="$1"
	print_separator
	echo "---- SETTING HOST NAME TO $hostname"
	hostnamectl set-hostname "$hostname"
	hostnamectl
	print_separator
}

# Function to create the etc/skel skeleton folders
create_skel_dirs() {
	print_separator
	echo '---- CONFIGURE SKEL FOLDERS FOR ALL USERS'
	mkdir /etc/skel/public_html
	mkdir /etc/skel/public_html/test
	print_separator
}

create_skel_test_files() {
	print_separator
	# add test for html
	echo "<html><body>Hello from HTML</body></html>" >/etc/skel/public_html/test/htmltest.html

	# add test script for php
	echo "<?php phpinfo(); ?>" >/etc/skel/public_html/test/phptest.php

	# add test script for perl
	echo "#!/usr/bin/perl" >/etc/skel/public_html/test/perltest.pl
	echo 'print "Content-type: text/html\n\n";' >>/etc/skel/public_html/test/perltest.pl
	echo 'print "Hello from Perl\n";' >>/etc/skel/public_html/test/perltest.pl
	chmod 755 /etc/skel/public_html/test/perltest.pl

	# add test script for python
	echo "#!/usr/bin/python3" >/etc/skel/public_html/test/pythontest.py
	echo 'print ("Content-type: text/html\n\n")' >>/etc/skel/public_html/test/pythontest.py
	echo 'print ("Hello from Python\n")' >>/etc/skel/public_html/test/pythontest.py
	chmod 755 /etc/skel/public_html/test/pythontest.py
	print_separator
}

# Function to add a new user
create_user() {
	print_separator
	echo "---- ADDING NEW USER $newusername"
	useradd -m "$newusername" -c "$newusername" -s '/bin/bash'
	echo "---- SETTING PASSWORD FOR $newusername TO $userpw"
	echo "$newusername:$userpw" | sudo chpasswd
	print_separator
}

# Function to install utility programs
install_utilities() {
	print_separator
	echo '---- INSTALLING A FEW UTILITY PROGRAMS'
	apt-get -qq install -y git bzip2 zip unzip screen net-tools
	print_separator
}

# Function to install Perl
install_perl() {
	print_separator
	echo '----PERL IS PREINSTALLED / INSTALL MYSQL DRIVER'
	perl --version
	apt-get -qq install -y libdbd-mysql-perl libdbi-perl
	print_separator
}

# Function to install Python3
install_python3() {
	print_separator
	echo '---- PYTHON AND PYTHON3 ARE PREINSTALLED / INSTALL MYSQL DRIVER'
	python3 --version
	apt-get -qq install -y python3-mysqldb
	print_separator
}

# Install web server with php
install_web_server() {
	print_separator
	echo '---- INSTALL APACHE2 WEB SERVER'
	apt-get -qq install -y apache2

	echo '---- INSTALL PHP8.1 WITH A FEW MODULES'
	apt-get -qq install -y php8.1 php8.1-mysql libapache2-mod-php8.1 php8.1-gd

	echo '---- CONFIGURE APACHE2 TO ALLOW CGI'
	echo "ServerName localhost" >/etc/apache2/conf-available/servername.conf
	a2enconf servername.conf
	sed -i 's/#AddHandler cgi-script .cgi/AddHandler cgi-script .cgi .pl .py .rb/' /etc/apache2/mods-available/mime.conf
	sed -i 's/IncludesNoExec/ExecCGI/' /etc/apache2/mods-available/userdir.conf
	a2enmod cgid
	a2disconf serve-cgi-bin

	echo '---- CONFIGURE APACHE2 TO ALLOW PUBLIC_HTML USER FOLDERS'
	sed -i 's/<IfModule mod_userdir.c>/#<IfModule mod_userdir.c>/' /etc/apache2/mods-available/php8.1.conf
	sed -i 's/    <Directory/#    <Directory/' /etc/apache2/mods-available/php8.1.conf
	sed -i 's/        php_admin_flag engine Off/#        php_admin_flag engine Off/' /etc/apache2/mods-available/php8.1.conf
	sed -i 's/    <\/Directory>/#    <\/Directory>/' /etc/apache2/mods-available/php8.1.conf
	sed -i 's/<\/IfModule>/#<\/IfModule>/' /etc/apache2/mods-available/php8.1.conf
	a2enmod userdir

	echo '---- FIXING APACHE ERROR LOG SO ALL USERS CAN READ IT'
	chmod 644 /var/log/apache2/error.log
	chmod 755 /var/log/apache2
	sed -i 's/create 640 root adm/create 644 root adm/' /etc/logrotate.d/apache2

	systemctl reload apache2
	systemctl restart apache2
	print_separator
}

# Install database server
install_database_server() {
	print_separator
	echo '---- INSTALLING MYSQL DATABASE SERVER'
	DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server
	echo "---- CREATING A TEST DATABASE FOR $newusername"
	mysql -uroot -e "create database $newusername"
	mysql -uroot -e "create user '$newusername'@'localhost' identified by '$userpw'"
	mysql -uroot -e "grant all privileges on $newusername.* to '$newusername'@'localhost' with grant option"
	mysql -uroot -e "flush privileges"
	mysql -u$newusername -p$userpw -e "use $newusername;drop table if exists address;create table address(name varchar(50) not null, street varchar(50) not null, primary key(name));"
	mysql -u$newusername -p$userpw -e "use $newusername;insert into address values('Jane', '123 Main Street');insert into address values('Bob', '222 Oak Street');insert into address values('Sue', '555 Trail Street');"
	print_separator
}

# Function to display footer
print_footer() {
	print_separator
	finishtime=$(date "+%s")
	elapsed_time=$((finishtime - starttime))
	echo "Elapsed time was $elapsed_time seconds."
	echo "The ip address is $(hostname -I)"
	print_separator
}

# Function to display header
print_header() {
	print_separator
	echo '---- UPDATING THE SYSTEM FOR VIRTUAL BOX UBUNTU 22.04 SERVER'
	echo '---- script developed by John Phillips 20160904 and updated 20240307'
	echo "---- bash script $0 run on $(date) by $(whoami) in folder $(pwd)"
	print_separator
}

# Main script starts here
print_header
update_system
set_hostname
create_skel_dirs
create_skel_test_files
create_user
chmod 0755 "/home/$newusername"
install_utilities
install_perl
install_python3
install_web_server
install_database_server
print_footer

# end of script
