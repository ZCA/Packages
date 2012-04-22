#
# Cookbook Name:: zenoss_build
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

product = node['zenoss_build']['build_flavor']
branch = node['zenoss_build']['branch']
repos = node['zenoss_build']['repos']
zenhome = node['zenoss_build']['zenhome']


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
  variables({
    :java_bin => node['java']['java_bin']
  })
end
#Copy a template .bash_profile file so set environment variables


# create zenhome
directory zenhome do
  owner "zenoss"
  group "zenoss"
  mode "0755"
  action :create
  recursive true
end


# source checkout
repos.each do |repo|
    subversion "zenoss repo" do
      Chef::Log.info("checking out #{repo}")
      user "zenoss"
      group "zenoss"
      repository repo
      revision branch
      destination "/home/zenoss/install-sources"
      action :sync
    end
end

