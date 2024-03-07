# Virtual Box and AWS Setup
Various scripts to ease setup of Virtual Box or AWS EC2 Ubuntu 22.04 servers for CS classroom, student, or home developer use.

## Prerequisites
### Virtual Box Setup
Install the latest Virtual Box along with the guest additions. Download the Ubuntu 22.04 server .iso file.
... more to come...

### AWS Setup
The following steps discuss how to setup Ubuntu 22.04 on an AWS micro instance. 
... more to come...

## Dev Servers
These scripts aid in setting up a developer server. The advantage of using shell scripts for this task
is that you can read the code to see what is going on and make changes to suit your situation.

### Text-Based
Running the d1.sh bash script will build text-based LAMP server 
with support for the Apache2 web server, the MySQL database server, and the Perl, Python, and PHP programming languages. 
This works great on a micro instance and probably will run okay on a nano instance. 
It easily keeps up with 30 or more users logged in at once.

On AWS, be sure to open firewall ports for http, ssh, and possibly TCP. 
I usually open http port 80 and port 8080 to the world and limit access to everything else using
the AWS firewall. I also have used the Ubuntu ufw firewall and sometimes have used denyhosts. 
Use whichever is best for your situation.

### Additional Programming languages
Run d2lang.sh to install additional programming languages and server. Under development....

## The following sections are dated and will be replaced soon
### GUI-Based
After running d1 you can next run the d2 script. This will create a Ubuntu Mate server that supports xrdp.
Students can log in remotely using Windows Remote Desktop on either Mac OS X or Windows. This option supports
IDEs such as Eclipse / STS, NetBeans, and others. However, it is recommended to use at least a medium instance with
4GB RAM for a single user. Each additional user might require another 2 GB or so depending on what apps they will be
running. I just have my students use free AWS Educate accounts and run their own dev server.

## Python Server
This is a simple server designed for a non-majors class I teach using Python. It is a Ubuntu Mate GUI xrdp server that allows
students to connect using Windows remote desktop. I tried to simplify the GUI to just the basics. A medium instance (4GB)
should be able to support 8 students at once or so given the simple software used. If you add an IDE then you might need
a lot more memory.

Be sure to open some AWS firewall ports to allow RDP from the IP addresses of your students.

## addusers.pl
I run this Perl script as root to setup all of the student Ubuntu accounts when we are sharing a class server. 
It is easy to get a list of student email addresses separated
by commas. I feed this into the addusers.pl script and it creates Linux accounts and MySQL accounts for each student.
Saves me a ton of work.
