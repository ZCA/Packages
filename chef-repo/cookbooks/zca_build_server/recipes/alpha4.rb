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

%w{tk unixODBC perl-DBI net-snmp net-snmp-utils gmp bc libgomp libxslt unzip binutils gcc make swig autoconf wget svn gcc-c++ protobuf-c libxml2-devel pango-devel}.each do |pkg|
  package pkg do
    action :install
  end
end
#These Packages failed on Centos 5.7, so handle them as such
if node.platform_version != "5.7" && platform?(%w{ redhat centos fedora suse scientific amazon })
	["liberation-fonts-common", "libgcj"].each do |pkg|
	  package pkg do
		action :install
	  end
	end
	
else
	Chef::Log.debug("TODO: Figure out what to do with these packages #{node['platform']} #{node['platform_version']}")
end

#MySQL
include_recipe "mysql::server55"

#Memcached
include_recipe "memcached"
#enable and start it
service "memcached" do
	action :enable
	action :start
end

include_recipe "erlang"
include_recipe "rabbitmq::zenoss"

#Java
include_recipe "java"

#We need Maven as wel
=begin
@TODO Come Back, it failed with 404
include_recipe "maven::maven3"
=end

#Python
=begin
@TODO: Come back to this, Based on the recipe I dont think it honors the node attribute for version to install
# and is instead installing 2.6
include_recipe "python"
=end
#Create Zenoss User
user "zenoss" do 
	comment "zenoss user"
	home "/home/zenoss"
end

#Setup users .bashrc
template "/home/zenoss/.bashrc" do
  source "zenoss_bashrc.erb"
end
#Copy a template .bash_profile file so set environment variables