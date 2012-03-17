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

%w{tk unixODBC perl-DBI net-snmp net-snmp-utils gmp bc libgomp libxslt unzip binutils gcc make swig autoconf wget}.each do |pkg|
  package pkg do
    action :install
  end
end

#Failed Packages- libgcj.x86_64, liberation-fonts-common

#Memcached
=begin
package "memcached" do
	action :install
end
service "memcached" do
	action :enable
	action :start
end

=end

