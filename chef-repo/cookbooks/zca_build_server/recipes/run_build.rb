#
# Cookbook Name:: zca_build_server
# Recipe:: run_build
#
# Maintainer - David Petzel
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

=begin
if node['platform'] == 'ubuntu' && node['platform_version'].split(".")[0] then
#I think the following hackery is likely a bad idea, but its the only way I could get this to work right
#Maybe some day there will be a better fix
#http://jira.zenoss.com/jira/browse/ZEN-1099?focusedCommentId=15072&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-15072
#Given that nonsense, apply some file hackery
execute "install.sh" do
	command "sed -i 's/threadsafe = True/threadsafe = False/' build/MySQL-python-1.2.3/site.cfg"
	cwd
	user  "zenoss"
	action :run
end

=end



#Once everything in place lets kick off the build process automatically
execute "install.sh" do
  command "./install.sh --no-prompt"
  cwd "/home/zenoss/install-sources"
  user  "zenoss"
  action :run
  environment ({'ZENHOME' => '/opt/zenoss',
				'PYTHONPATH' => '$ZENHOME/lib/python',
				'PATH' => '/usr/bin/:/bin:$ZENHOME/bin:$PATH:/usr/lib/jvm/jdk1.6.0_31/bin/',
				'INSTANCE_HOME' => '$ZENHOME'
			  })
end
