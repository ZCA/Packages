#
# Cookbook Name:: zca_build_server
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#Temporary Hack to to work around http://tickets.opscode.com/browse/CHEF-3135
file_to_patch = "/usr/lib/ruby/gems/1.8/gems/chef-0.10.10/lib/chef/mixin/enforce_ownership_and_permissions.rb" 
remote_file file_to_patch do
  source "https://raw.github.com/opscode/chef/527cf2e2d4b565726c890e85c710f3632c7f3700/chef/lib/chef/mixin/enforce_ownership_and_permissions.rb"
  only_if {File.exists?(file_to_patch)}
end

#End temp hack

case node['platform']
when %w{ redhat centos fedora suse scientific amazon }
  include_recipe "yum::epel"
when "ubuntu"
  include_recipe "apt"
  #Add external PPA for MySQL 5.5 Packages
    apt_repository "mysql" do
      uri "http://ppa.launchpad.net/nathan-renniewaldock/ppa/ubuntu"
	  distribution node['lsb']['codename']
      components ["main"]
      keyserver "keyserver.ubuntu.com"
      key "29A4B41A"
    end
end

#Disable IPTABLES:
service "iptables" do
	action :disable
end

#Subversion
include_recipe "subversion"

#MySQL
#Come back to this
include_recipe "mysql::server"

#Memcached
include_recipe "memcached"
include_recipe "erlang"
include_recipe "rabbitmq::zenoss"


#Java
include_recipe "java"


#We need Maven as wel
include_recipe "maven::maven3"

# let's get the base build packages for whatever platform we're on
include_recipe "zca_build_server::build_packages"

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

#Run the build
include_recipe "zca_build_server::run_build"

