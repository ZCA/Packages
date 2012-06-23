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

#Once everything in place lets kick off the build process automatically
execute "install.sh" do
  command "install.sh --no-prompt"
  cwd "/home/zenoss/install-sources"
  user  "zenoss"
  action :run
end