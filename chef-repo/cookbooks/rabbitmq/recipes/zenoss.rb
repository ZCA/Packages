#Extend the default rabbitmq recipe

include_recipe "rabbitmq"

#Add the Users we need
rabbitmq_user "zenoss" do 
	password "zenoss" 
	action :add 
end

#Add the vhost
rabbitmq_vhost "/zenoss" do 
	action :add 
end

#Set Permissions
rabbitmq_user "zenoss" do 
	vhost "/zenoss" 
	permissions "\".\" \".\" \".*\"" 
	action :set_permissions 
end