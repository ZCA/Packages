################################
#
# We need mysql 5.5
#
################################


#Download MySQL RPMs
if platform?(%w{ redhat centos fedora suse scientific amazon })
	
	%w{MySQL-server-5.5.21-1.linux2.6.x86_64.rpm MySQL-client-5.5.21-1.linux2.6.x86_64.rpm MySQL-devel-5.5.21-1.linux2.6.x86_64.rpm}.each do |rpm_file|
		remote_file "/tmp/#{rpm_file}" do
		  source "http://www.mysql.com/get/Downloads/MySQL-5.5/#{rpm_file}/from/http://mysql.llarian.net/"
		  action :create_if_missing
		end
		rpm_package "#{rpm_file}" do
		  source "/tmp/#{rpm_file}"
		  only_if {::File.exists?("/tmp/#{rpm_file}")}
		  action :install
		end
	end
=begin
	cookbook_file "/tmp/MySQL-server-5.5.21-1.linux2.6.x86_64.rpm" do
		path "http://www.mysql.com/get/Downloads/MySQL-5.5/MySQL-server-5.5.21-1.linux2.6.x86_64.rpm/from/http://mysql.llarian.net/"
		action :create_if_missing
	end
	cookbook_file "/tmp/MySQL-client-5.5.21-1.linux2.6.x86_64.rpm" do
		path "http://www.mysql.com/get/Downloads/MySQL-5.5/MySQL-client-5.5.21-1.linux2.6.x86_64.rpm/from/http://mysql.llarian.net/"
		action :create_if_missing
	end
	cookbook_file "/tmp/MySQL-devel-5.5.21-1.linux2.6.x86_64.rpm" do
		path "http://www.mysql.com/get/Downloads/MySQL-5.5/MySQL-devel-5.5.21-1.linux2.6.x86_64.rpm/from/http://mysql.llarian.net/"
		action :create_if_missing
	end
=end
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