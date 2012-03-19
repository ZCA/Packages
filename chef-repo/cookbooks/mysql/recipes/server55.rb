################################
#
# We need mysql 5.5
#
################################


#Download MySQL RPMs
arch="#{node['kernel']['machine']}"
if platform?(%w{ redhat centos fedora suse scientific amazon })
	rpm_list = ["MySQL-client-5.5.21-1.linux2.6.#{arch}.rpm", "MySQL-devel-5.5.21-1.linux2.6.#{arch}.rpm", "MySQL-server-5.5.21-1.linux2.6.#{arch}.rpm"]
	rpm_list.each do |rpm_file|
		remote_file "/tmp/#{rpm_file}" do
		  source "http://www.mysql.com/get/Downloads/MySQL-5.5/#{rpm_file}/from/http://mysql.llarian.net/"
		  #Avoid downloading every single execution.
		  not_if "rpm -qa | egrep -qi 'MySQL-server-5.5'"
		  notifies :install, "rpm_package[#{rpm_file}]", :immediately
		end
		rpm_package "#{rpm_file}" do
		  source "/tmp/#{rpm_file}"
		  only_if {::File.exists?("/tmp/#{rpm_file}")}
		  #Action nothing seems odd at first glance. What happens is that by default we dont want to try install this.
		  #Instead, if the remote_file above results in a file download, it notified this to and sets the action to install.
		  #This results in idempotent download-->install
		  action :nothing
		end
	end
elsif platform?(%w{ ubuntu})
	deb_file="mysql-5.5.21-debian6.0-#{arch}.deb"
	Chef::Log.info("#{deb_file}")
	remote_file "/tmp/#{deb_file}" do
	  source "http://www.mysql.com/get/Downloads/MySQL-5.5/#{deb_file}/from/http://mysql.he.net/"
	  #Avoid downloading every single execution.
	  not_if "dpkg --list | egrep -q mysql | grep 5.5"
	  notifies :install, "dpkg_package[#{deb_file}]", :immediately
	end
	dpkg_package "#{deb_file}" do
	  source "/tmp/#{deb_file}"
	  only_if {::File.exists?("/tmp/#{deb_file}")}
		  #Action nothing seems odd at first glance. What happens is that by default we dont want to try install this.
		  #Instead, if the remote_file above results in a file download, it notified this to and sets the action to install.
		  #This results in idempotent download-->install
	  action :nothing	
	end
end

#Enable and Start MySQL
service "mysql" do
	supports :status => true, :restart => true, :reload => true
	action [ :enable, :start ]
end

#Set Password
execute "assign-root-password" do
	command "#{node['mysql']['mysqladmin_bin']} -u root password \"#{node['mysql']['server_root_password']}\""
	action :run
end
execute "assign-root-password" do
	command "#{node['mysql']['mysqladmin_bin']} -u root -h localhost password \"#{node['mysql']['server_root_password']}\""
	action :run
end