################################
#
# We need mysql 5.5
#
################################

include_recipe "mysql::cleanup_mysql"

#TODO: use this for now, but move to using REMI repo for Redhat

#Download MySQL RPMs
arch="#{node['kernel']['machine']}"
if platform?(%w{ redhat centos fedora suse scientific amazon })
    Chef::Log.info("=======================================================================================")
	rpm_list = ["MySQL-client-5.5.21-1.linux2.6.#{arch}.rpm", "MySQL-devel-5.5.21-1.linux2.6.#{arch}.rpm", "MySQL-shared-5.5.21-1.linux2.6.#{arch}.rpm"]
	Chef::Log.info("installing #{rpm_list}")
	rpm_list.each do |rpm_file|
		remote_file "/tmp/#{rpm_file}" do
		  source "http://www.mysql.com/get/Downloads/MySQL-5.5/#{rpm_file}/from/http://mysql.llarian.net/"
		  #Don't Download if its already installed
		  not_if "rpm -qa | egrep -qi 'MySQL-shared-5.5'"
		  notifies :install, "rpm_package[#{rpm_file}]", :immediately
		  #If we already downloaded it, don't download it again. Unlikely to be useful in the real world, but a time saver during dev/testing
		  action :create_if_missing
		end
		rpm_package "#{rpm_file}" do
		  source "/tmp/#{rpm_file}"
		  only_if {::File.exists?("/tmp/#{rpm_file}")}
		  #Action nothing seems odd at first glance. What happens is that by default we dont want to try install this.
		  #Instead, if the remote_file above results in a file download, it notified this to and sets the action to install.
		  #This results in idempotent download-->install
		  action :nothing
		end
	end # redhat
	
elsif platform?(%w{ ubuntu})
    # adding the mysql 5.5 ubuntu repo
    Chef::Log.info("adding nathan's ppa for #{node['lsb']['codename']}")
    # add the Nginx PPA; grab key from keyserver
    apt_repository "mysql" do	
      uri "http://ppa.launchpad.net/nathan-renniewaldock/ppa/ubuntu"
      distribution node['lsb']['codename']
      components ["main"]
      keyserver "keyserver.ubuntu.com"
      key "C8716B42"
    end

    %w{mysql-client-5.5 libmysqlclient-dev}.each do |pkg|
        package pkg do
            action :install
        end
    end # ubuntu

end 


