=======================
Source Installation EL6
=======================

.. contents::
   :depth: 4
   

64 Bit
******
  
What Is This
============
Notes from my attempt to install Alpha 4 on Centos 6.2 from Source

***THIS DOES NOT WORK YET***

The Steps
=========
This is the process that worked for me, it may not be the most optimal
and your mileage may vary. In some cases I've split groups of commands
onto multiple lines for readability

Start by turning off iptables. Security nuts, feel free to open only the
required ports as listed in the official installation guide::

   service iptables stop
   chkconfig iptables off
  
Ensure your umaks is set::

   umask 022
  
Install Pre-Req Packages::

   yum -y install binutils gcc make swig autoconf wget
  
Download and Install MySQL Components::
   
   cd /tmp
   wget http://www.mysql.com/get/Downloads/MySQL-5.5/MySQL-server-5.5.21-1.linux2.6.x86_64.rpm/from/http://mysql.llarian.net/
   wget http://www.mysql.com/get/Downloads/MySQL-5.5/MySQL-client-5.5.21-1.linux2.6.x86_64.rpm/from/http://mysql.llarian.net/
   wget http://www.mysql.com/get/Downloads/MySQL-5.5/MySQL-devel-5.5.21-1.linux2.6.x86_64.rpm/from/http://mysql.llarian.net/
   rpm -ivh MySQL-client-5.5.21-1.linux2.6.x86_64.rpm 
   rpm -ivh MySQL-server-5.5.21-1.linux2.6.x86_64.rpm
   rpm -ivh MySQL-devel-5.5.21-1.linux2.6.x86_64.rpm
   
Configure MySQL to start automatically, start it and ensure a blank password::

   chkconfig mysql on
   service mysql start
   mysqladmin -u root password ''
   mysqladmin -u root -h localhost password ''
  
Install Pre-Req Packages::
   
   #Splitting on multiple lines for readability only
   yum -y install tk unixODBC memcached perl-DBI net-snmp net-snmp-utils gmp bc
   yum -y install libgomp libgcj.x86_64 libxslt liberation-fonts-common unzip
   chkconfig memcached on
   service memcached start
  

Install erlang (Needed by RabbitMq). I'm not aware of an available RPM, so from source
Additionally, I couldnt get around using epel for this. Someone with some more
skillz than me, might be able to get this working without epel::

   rpm -ivh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-5.noarch.rpm
   yum -y install erlang
   #done with epel, remove it
   rpm -e epel-release

Install RabbitMQ::

   wget http://www.rabbitmq.com/releases/rabbitmq-server/v2.7.1/rabbitmq-server-2.7.1-1.noarch.rpm
   rpm -ivh rabbitmq-server-2.7.1-1.noarch.rpm
   chkconfig rabbitmq-server on
   service rabbitmq-server start
  
Create a zenoss user for RabbitMQ (Internal to RabbitMQ User)::

   rabbitmqctl add_user zenoss zenoss 
   rabbitmqctl add_vhost /zenoss
   rabbitmqctl set_permissions -p /zenoss zenoss '.*' '.*' '.*'
   
Install Java JRE::

   wget http://download.oracle.com/otn-pub/java/jdk/6u31-b04/jre-6u31-linux-x64-rpm.bin
   chmod +x jre-6u31-linux-x64-rpm.bin
   ./jre-6u31-linux-x64-rpm.bin
  
Install Python27 (This method MIGHT be dangerous for YUM, I don't know enough yet to  be sure)
Maybe look at creating an RPM: https://bitbucket.org/st3fan/fxhome/changeset/9386908e927d::

  wget http://www.python.org/ftp/python/2.7.2/Python-2.7.2.tgz
  tar -zxvf Python-2.7.2.tgz
  cd Python-2.7.2
  ./configure -with-zlib=/usr/include
  make
  make install
  echo /usr/local/lib >> /etc/ld.so.conf

Setup User and Environment::

   useradd zenoss
   
   echo export ZENHOME=/opt/zenoss >> /home/zenoss/.bash_profile
   echo export PYTHONPATH=$ZENHOME/lib/python:$ZENHOME/ >> /home/zenoss/.bash_profile
   echo export PATH=$ZENHOME/bin:$PATH >> /home/zenoss/.bash_profile
   echo export INSTANCE_HOME=$ZENHOME >> /home/zenoss/.bash_profile
   
   mkdir /opt/zenoss
   chown zenoss /opt/zenoss
  
Install Subversion Client and Pull The Source::

   yum -y install svn gcc-c++ protobuf-c libxml2-devel pango-devel
   
Fix some files
 * Insert the following into line *160* of install-functions.sh. It appears
   that this file gets created without execute permissions (despite our umask)
   and needs to be executable::
   
      chmod a+x $ZENHOME/bin/zenglobalconf
  
Install Maven. We need the Java JDK for this::

   wget http://download.oracle.com/otn-pub/java/jdk/6u31-b04/jdk-6u31-linux-x64.bin
   chmod +x jdk-6u31-linux-x64.bin
   ./jdk-6u31-linux-x64.bin
   #press enter when prompted
   mv jdk1.6.0_31 /usr/java
   
   http://linux-files.com//maven/binaries/apache-maven-3.0.4-bin.tar.gz
   tar -zxvf apache-maven-3.0.4-bin.tar.gz -C /opt
   ln -s /opt/apache-maven-3.0.4/bin/mvn /usr/sbin/mvn 
   
   
   su - zenoss
   PATH=/opt/zenoss/bin/:$PATH:/usr/java/jdk1.6.0_31/bin/
   PYTHONPATH=$PYTHONPATH:$ZENHOME/
   cd /tmp
   svn co http://dev.zenoss.org/svn/trunk/inst zenossinst
   cd zenossinst
   ./install.sh

Answer as Follows (all Defaults)::

   Relstorage db type [mysql]:
   Relstorage host [localhost]:
   Relstorage port [3306]:
   Relstorage admin username [root]:
   Relstorage admin password []:
   Relstorage database name [zodb]:
   Relstorage db username [zenoss]:
   Relstorage db user password [zenoss]:
   ZEP db type [mysql]:
   ZEP db host [localhost]:
   ZEP db port [3306]:
   ZEP db admin username [root]:
   ZEP db admin password []:
   ZEP db name [zenoss_zep]:
   ZEP db username [zenoss]:
   ZEP db password [zenoss]:
   RabbitMQ hostname [localhost]:
   RabbitMQ SSL [y/N]:
   RabbitMQ port [5672]:
   RabbitMQ virtual host [/zenoss]:
   RabbitMQ username [zenoss]:
   RabbitMQ password [zenoss]:

Go get a coffee or soda, your going to be waiting for a while


32 Bit
******
TBD


