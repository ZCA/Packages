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

%w{wget tk unixODBC perl-DBI net-snmp net-snmp-utils gmp bc libgomp libxslt unzip}.each do |pkg|
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

#Download MySQL Files
remote_file "#{Chef::Config[:file_cache_path]}/MySQL-server-5.5.21-1.linux2.6.x86_64.rpm" do
  source "http://www.mysql.com/get/Downloads/MySQL-5.5/MySQL-server-5.5.21-1.linux2.6.x86_64.rpm/from/http://mysql.llarian.net/"
  not_if "rpm -qa | egrep -qx 'MySQL-server'"
  notifies :install, "rpm_package[mysql_install]", :immediately
end

rpm_package "mysql_install" do
  source "#{Chef::Config[:file_cache_path]}/MySQL-server-5.5.21-1.linux2.6.x86_64.rpm"
  only_if {::File.exists?("#{Chef::Config[:file_cache_path]}/MySQL-server-5.5.21-1.linux2.6.x86_64.rpm")}
  action :nothing
end
=end

