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

# let's get the base build packages for whatever platform we're on
include_recipe "zca_build_server::build_packages"


#Subversion
include_recipe "subversion"

#MySQL
#Come back to this
include_recipe "mysql::client55"

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


#checkout code from repo
include_recipe "zenoss_build"

