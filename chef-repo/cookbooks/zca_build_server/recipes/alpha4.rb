#
# Cookbook Name:: zca_build_server
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


#Disable IPTABLES:
service "iptables" do
	action :disable
end

%w{tk unixODBC bc  unzip binutils gcc make swig autoconf wget }.each do |pkg|
  package pkg do
    action :install
  end
end
#rhel specific packages
if platform?(%w{ redhat centos fedora suse scientific amazon })
	%w{ perl-DBI rpm-build net-snmp net-snmp-utils gmp libgomp libxslt gcc-c++ libxml2-devel pango-devel}.each do |pkg|
		package pkg do
			action :install
		end
	end
	#Create rpmbuild User
	user "rpmbuild" do 
		comment "rpmbuild user"
	end
	#These Packages failed on Centos 5.7, so handle them as such
	if node.platform_version != "5.7"
		["liberation-fonts-common"].each do |pkg|
		  package pkg do
			action :install
		  end
		end
		
	else
		#We need some stuff from epel
		include_recipe "yum::epel"
		#Centos 5x its liberation-fonts, not common
		["liberation-fonts", "protobuf-devel"].each do |pkg|
			package pkg do
				action :install
			end
		end
		#Chef::Log.debug("TODO: Figure out what to do with protobuf-c package #{node['platform']} #{node['platform_version']}")
	end
elsif platform?(%w{ ubuntu })
	%w{ libdbi-perl libsnmp-base libsnmp15 snmp snmpd libsnmp-dev libgmp3-dev build-essential libxml2-dev libreadline6-dev}.each do |pkg|
		package pkg do
			action :install
		end
	end
	#Split for readability
	%w{ libpango1.0-dev libgcj10 ccache gcc-4.4 libxslt1-dev libcairo2-dev libglib2.0-dev libevent-dev ldap-utils libldap2-dev libsasl2-dev}.each do |pkg|
		package pkg do
			action :install
		end
	end
	
end

#Subversion
include_recipe "subversion"

#MySQL
if platform?(%w{ redhat centos fedora suse scientific amazon })
	include_recipe "mysql::server55"
elsif platform?(%w{ ubuntu })
	Chef::Log.warn("So far, I have not found a clean method to install mysql 5.5 on ubuntu. With a little time I'm sure its possible, but as of right now, no dice")	
end



#Memcached
include_recipe "memcached"

include_recipe "erlang"
include_recipe "rabbitmq::zenoss"

#Java
include_recipe "java"

#We need Maven as wel
include_recipe "maven::maven3"

#Python
#Pretty sure Ubuntu has packages available, but rhel derivs need from source
if platform?(%w{ redhat centos fedora suse scientific amazon })
	#The version is set in the node attributes
	include_recipe "python::source"
else
  package "python" do
	version #{node['python']['version']}
    action :install
  end	
end



#Create Zenoss User
user "zenoss" do 
	comment "zenoss user"
	home "/home/zenoss"
	shell "/bin/bash"
	supports :manage_home => true
end

#Setup users .bashrc
template "/home/zenoss/.bashrc" do
  source "zenoss_bashrc.erb"
  owner "zenoss"
  group "zenoss"
end

#Create Zenoss installation directory
if platform?(%w{ redhat centos fedora suse scientific amazon })
	zenhome="/opt/zenoss"
elsif platform?(%w{ ubuntu })
	zenhome="/usr/local/zenoss"
end
#Now that we know WHERE its going, create it and set permissions
directory "#{zenhome}" do
  owner "zenoss"
  group "zenoss"
  mode "0755"
  action :create
end