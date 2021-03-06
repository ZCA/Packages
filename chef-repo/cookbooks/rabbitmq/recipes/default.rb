#
# Cookbook Name:: rabbitmq
# Recipe:: default
#
# Copyright 2009, Benjamin Black
# Copyright 2009-2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# rabbitmq-server is not well-behaved as far as managed services goes
# we'll need to add a LWRP for calling rabbitmqctl stop
# while still using /etc/init.d/rabbitmq-server start
# because of this we just put the rabbitmq-env.conf in place and let it rip

directory "/etc/rabbitmq/" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

template "/etc/rabbitmq/rabbitmq-env.conf" do
  source "rabbitmq-env.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[rabbitmq-server]"
end

case node[:platform]
when "debian", "ubuntu"
  # use the RabbitMQ repository instead of Ubuntu or Debian's
  # because there are very useful features in the newer versions
  apt_repository "rabbitmq" do
    uri "http://www.rabbitmq.com/debian/"
    distribution "testing"
    components ["main"]
    key "http://www.rabbitmq.com/rabbitmq-signing-key-public.asc"
    action :add
  end
  package "rabbitmq-server"
when "redhat", "centos", "scientific"
  include_recipe "yum::epel"
  yum_repository "erlang" do
    name "EPELErlangrepo"
    url "http://repos.fedorapeople.org/repos/peter/erlang/epel-5Server/$basearch"
    description "Updated erlang yum repository for RedHat / Centos 5.x - #{node['kernel']['machine']}"
    action :add
    only_if { node[:platform_version].to_f >= 5.0 && node[:platform_version].to_f < 6.0 }
  end
  package "rabbitmq-server"
else
  package "rabbitmq-server"
end



if node[:rabbitmq][:cluster]
    # If this already exists, don't do anything
    # Changing the cookie will stil have to be a manual process
    template "/var/lib/rabbitmq/.erlang.cookie" do
      source "doterlang.cookie.erb"
      owner "rabbitmq"
      group "rabbitmq"
      mode 0400
      not_if { File.exists? "/var/lib/rabbitmq/.erlang.cookie" }
    end
end

template "/etc/rabbitmq/rabbitmq.config" do
  source "rabbitmq.config.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[rabbitmq-server]"
end

service "rabbitmq-server" do
  stop_command "/usr/sbin/rabbitmqctl stop"
  supports :status => true, :restart => true
  action [ :enable, :start ]
end
