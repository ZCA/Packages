#
# Cookbook Name:: zca_build_server
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

install_packages = node['zca_build_server']['build_packages']

Chef::Log.info("installing the following packages: #{install_packages}")

#rhel specific packages
if platform?(%w{ redhat centos fedora suse scientific amazon })

	#Create rpmbuild User
	user "rpmbuild" do 
		comment "rpmbuild user"
	end

    #We need some stuff from epel & remi
    #take out remi since mysql comes from mysql.com for now
	include_recipe "yum::epel"
	#include_recipe "yum::remi"
	
elsif platform?(%w{ ubuntu })
    # anything specific to ubuntu would go here
    # TODO: prolly need to add mysql 5.5 source here
	
end


# install the packages now
install_packages.each do |pkg|
  package pkg do
    action :install
  end
end
