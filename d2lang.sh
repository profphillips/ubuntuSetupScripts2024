
install_ruby() {
	print_separator
	echo '---- INSTALLING RUBY WHICH IS PREINSTALLED ON VAGRANT BUT NOT ON VIRTUALBOX OR AWS'
	apt-get -qq install -y ruby
	ruby --version
	# add test script for ruby
	echo "#!/usr/bin/ruby" > /etc/skel/public_html/test/rubytest.rb
	echo 'print "Content-type: text/html\n\n"' >> /etc/skel/public_html/test/rubytest.rb
	echo 'print "<html><body><p>Hello using Ruby!</p></body></html>"' >> /etc/skel/public_html/test/rubytest.rb
	chmod 755 /etc/skel/public_html/test/rubytest.rb
	print_separator	
}

install_java_8() {
	print_separator
	echo '---- INSTALLING JAVA OPEN-JDK-8 COMPILER'
	apt-get -qq install -y openjdk-8-jdk java-common
	# update-alternatives --set java /usr/lib/jvm/java-21-openjdk-amd64/bin/java
	# echo 'JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"' >> /etc/environment
	javac -version
	java -version
	echo '---- INSTALLING JAVA/MYSQL JDBC DRIVER'
	# apt-get -qq install -y libmysql-java
	apt-get -qq install -y libmariadb-java
	# echo 'CLASSPATH=.:/usr/share/java/mysql-connector-java.jar' >> /etc/environment
	echo 'CLASSPATH=.:/usr/share/java/mariadb-java-client.jar' >> /etc/environment
	print_separator
}


install_java_21() {
	print_separator
	echo '---- INSTALLING JAVA OPEN-JDK-21 COMPILER'
	apt-get -qq install -y openjdk-21-jdk java-common
	update-alternatives --set java /usr/lib/jvm/java-21-openjdk-amd64/bin/java
	echo 'JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"' >> /etc/environment
	javac -version
	java -version
	# echo '---- INSTALLING JAVA/MYSQL JDBC DRIVER'
	# apt-get -qq install -y libmysql-java
	# apt-get -qq install -y libmariadb-java
	# echo 'CLASSPATH=.:/usr/share/java/mysql-connector-java.jar' >> /etc/environment
	print_separator
}

install_c() {
	print_separator
	echo '---- INSTALLING C AND C++ COMPILERS'
	apt-get -qq install -y build-essential
	gcc --version
	g++ --version
	print_separator	
}

install_csharp() {
	print_separator
	echo '---- INSTALLING C# COMPILER'
	apt-get -qq install -y mono-complete
	mono
	print_separator	
}

install_go() {
	print_separator
	echo '---- INSTALLING GO'
	apt-get -qq install -y golang
	go version
	print_separator	
}

install_clojure() {
	print_separator
	echo '---- INSTALLING CLOJURE'
	apt-get install -y clojure
	print_separator	
}

install_fortran() {
	print_separator
	echo '---- INSTALLING FORTRAN COMPILER'
	apt-get install -y gfortran
	gfortran --version
	print_separator	
}

install_cobol() {
	print_separator
	echo '---- INSTALLING COBOL COMPILER'
	apt-get install -y open-cobol
	cobc -V
	print_separator	
}

install_pl1() {
	print_separator
	echo '---- INSTALLING PL/I COMPILER'
	wget http://www.iron-spring.com/pli-0.9.9.tgz
	tar -xvzf pli-1.2.0.tgz
	cd pli-1.2.0
	make install
	cd ..
	rm -f pli-1.2.0.tgz
	plic -V
	print_separator	
}

install_nodejs() {
	print_separator
	echo '---- INSTALLING NODEJS'
	apt-get install -y nodejs
	node -v
	echo '---- INSTALLING NPM'
	apt-get install -y npm
	print_separator	
}

install_ruby
install_java_8
install_java_21
install_c
install_csharp
install_go
install_clojure
install_fortran
install_cobol
install_pl1
install_nodejs