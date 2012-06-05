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
The following command, run as root, should install the Chef Client on most 'nix systems::

    curl -L http://www.opscode.com/chef/install.sh | sudo bash

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
   alias chefzca='chef-solo -c /tmp/zca_packages/chef-repo/.chef/solo.rb -j /tmp/zca_packages/chef-repo/nodes/zca_build_server.json'
   
Chef Will Take It From Here
===========================
That should pretty much do it, just kick chef-solo into gear using our new alias::

  chefzca
  
**I noticed on Centos 5.7, that something in the RabbitMQ recipe croaks on first
execution, running chefzca a second time (doing nothing else), results in everything
completing without error**
