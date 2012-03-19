========================
Setup a ZCA Build Server
========================

.. contents::
   :depth: 3
   
   
Intro
=====
Lets use Chef to provision build servers. Start by getting the chef client
installed onto your new build server machine. Don't worry about Chef server
we will only by using Chef-Solo

Install Chef Client
===================
Centos 6
********
Run the following to install chef client on Centos 6::

   rpm -Uvh http://rbel.frameos.org/rbel6
   yum -y install ruby ruby-devel ruby-ri ruby-rdoc ruby-shadow gcc gcc-c++ automake autoconf make curl dmidecode
   cd /tmp
   curl -O http://production.cf.rubygems.org/rubygems/rubygems-1.8.10.tgz
   tar zxf rubygems-1.8.10.tgz
   cd rubygems-1.8.10
   ruby setup.rb --no-format-executable
   gem install chef --no-ri --no-rdoc
   #Ensure it works
   chef-solo -v
   

Centos 5
********
Run the following to install chef client on Centos 5::
  
   rpm -ivh http://rbel.co/rbel5
   yum -y install ruby.x86_64 ruby-devel.x86_64 rubygems gcc
   gem install chef --no-ri --no-rdoc
   #Ensure it works
   chef-solo -v
   
Ubuntu
******
Run the following to install chef client on Ubuntu::

   sudo apt-get update
   sudo apt-get install ruby ruby-dev libopenssl-ruby rdoc ri irb build-essential wget ssl-cert git-core
   cd /tmp
   wget http://production.cf.rubygems.org/rubygems/rubygems-1.8.10.tgz
   tar zxf rubygems-1.8.10.tgz
   cd rubygems-1.8.10
   sudo ruby setup.rb --no-format-executable
   sudo gem install chef --no-ri --no-rdoc
   #Ensure it works
   chef-solo -v


Configure Chef Solo
===================
Run the following commands to get setup to use the ZCA build cookbooks::

      
   cd /tmp
   wget --no-check-certificate -N https://github.com/ZCA/Packages/zipball/master -O master.zip
   #the output folder name is random, hence the move
   unzip master.zip && mv ZCA-Packages* zca_packages
   mkdir /etc/chef
   cp /tmp/zca_packages/chef-repo/.chef/solo.rb /etc/chef
   #Create an alias to save typing, not required
   alias chefsolo='chef-solo -c /tmp/zca_packages/chef-repo/.chef/solo.rb -j /tmp/zca_packages/chef-repo/nodes/zca_build_server.json'
   
Chef Will Take It From Here
===========================
That should pretty much do it, just kick chef-solo into gear using our new alias::

  chefsolo
  
**I noticed on Centos 5.7, that something in the RabbitMQ recipe croaks on first
execution, running chefsolo a second time (doing nothing else), results in everything
completing without error**
