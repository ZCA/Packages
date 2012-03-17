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

%w{tk unixODBC net-snmp net-snmp-utils gmp bc libgomp libxslt unzip binutils gcc make swig autoconf wget gcc-c++ libxml2-devel pango-devel libgcj}.each do |pkg|
  package pkg do
    action :install
  end
end
#rhel specific packages
if platform?(%w{ redhat centos fedora suse scientific amazon })
	%w{ perl-DBI rpm-build }.each do |pkg|
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
	%w{ libdbi-perl }.each do |pkg|
		package pkg do
			action :install
		end
	end
end

#Subversion
include_recipe "subversion"

#MySQL
include_recipe "mysql::server55"

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
end

#Setup users .bashrc
template "/home/zenoss/.bashrc" do
  source "zenoss_bashrc.erb"
  owner "zenoss"
  group "zenoss"
end
#Copy a template .bash_profile file so set environment variables