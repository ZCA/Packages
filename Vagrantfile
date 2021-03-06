# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant Configuratoin Files for Building Zenoss Build Servers
# On Various Platforms
# Some nice basebox templates: http://vagrant.sensuapp.org/list

Vagrant::Config.run do |config|
  #Configure a Cento
  config.vm.define :centos5 do |centos5_config|
    centos5_config.vm.box = "centos5"
    centos5_config.vm.forward_port 8080, 8080
    centos5_config.vm.boot_mode = :headless #(gui or headless)
    centos5_config.vm.box_url = "http://dl.dropbox.com/u/8072848/centos-5.7-x86_64.box"
    centos5_config.vm.customize ["modifyvm", :id, "--memory", 2048]
    centos5_config.vm.customize ["modifyvm", :id, "--cpus", 2]
  end
  config.vm.define :centos6 do |centos6_config|
    centos6_config.vm.box = "centos6"
    centos6_config.vm.forward_port 8080, 8080
    centos6_config.vm.boot_mode = :headless #(gui or headless)
    centos6_config.vm.box_url = "http://dl.dropbox.com/u/36836372/centos6_64-veewee.BoxesCentOS-6.0-x86_64"
    centos6_config.vm.customize ["modifyvm", :id, "--memory", 2048]
    centos6_config.vm.customize ["modifyvm", :id, "--cpus", 2]
  end
  config.vm.define :ubuntu10 do |ubuntu10_config|
    ubuntu10_config.vm.box = "ubuntu10"
    ubuntu10_config.vm.forward_port 8080, 8080
    ubuntu10_config.vm.boot_mode = :headless #(gui or headless)
    ubuntu10_config.vm.box_url = "http://files.vagrantup.com/lucid64.box"
    ubuntu10_config.vm.customize ["modifyvm", :id, "--memory", 2048]
    ubuntu10_config.vm.customize ["modifyvm", :id, "--cpus", 2]
  end
  config.vm.define :ubuntu11 do |ubuntu11_config|
    ubuntu11_config.vm.box = "ubuntu11"
    ubuntu11_config.vm.forward_port 8080, 8080
    ubuntu11_config.vm.boot_mode = :gui #(gui or headless)
    ubuntu11_config.vm.box_url = "http://timhuegdon.com/vagrant-boxes/ubuntu-11.10.box"
    ubuntu11_config.vm.customize ["modifyvm", :id, "--memory", 2048]
    ubuntu11_config.vm.customize ["modifyvm", :id, "--cpus", 2]
  end
  config.vm.define :ubuntu12 do |ubuntu12_config|
    ubuntu12_config.vm.box = "ubuntu12"
    ubuntu12_config.vm.forward_port 8080, 8080
    ubuntu12_config.vm.boot_mode = :headless #(gui or headless)
    ubuntu12_config.vm.box_url = "http://vagrant.sensuapp.org/ubuntu-1204-amd64.box"
    ubuntu12_config.vm.customize ["modifyvm", :id, "--memory", 2048]
    ubuntu12_config.vm.customize ["modifyvm", :id, "--cpus", 2]
  end
  
  
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "./chef-repo/cookbooks"
    chef.roles_path = "./chef-repo/roles"
    chef.data_bags_path = "./chef-repo/data_bags"
    #chef.add_recipe "zca_build_server::alpha4"
    chef.add_role "zca_build_server"
    
    # Custom Node Level Attributes. These are primarily driven by cookbooks
    # That require attributes be set for them to perform properly
    chef.json = { 	"java" =>{"install_flavor" => "oracle"},
					"python"=> {"distribute_install_py_version" => "2.7", 
								"version"=> "2.7.2", 
								"checksum"=> "ba7b2f11ffdbf195ee0d111b9455a5bd"
					 },
					 "mysql" => {"server_root_password" => "",
								 "server_repl_password" => "",
								 "server_debian_password" => ""
								}
    			}
  end
end
