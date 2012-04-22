#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: zenoss_build
# Attributes:: default 
#
# Copyright 2010, Opscode, Inc.
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

# default zenoss to build (core-public, core-private, enterprise, etc.)
default['zenoss_build']['build_flavor'] = "core-public"
default['zenoss_build']['branch'] = 'HEAD'
default['zenoss_build']['zenhome'] = '/opt/zenoss'

case default['zenoss_build']['build_flavor']
when "core-public"
  default['zenoss_build']['repos'] = ["http://dev.zenoss.org/svn/trunk/inst"]
when "core-private"
  default['zenoss_build']['repos'] = ["http://dev.zenoss.com/svnint/trunk/core/inst"]
#when "enterprise"
#  default['zenoss_build']['repos'] = ["http://dev.zenoss.com/svnint/trunk/core/inst","http://dev.zenoss.com/svnint/trunk/enterprise/zenpacks"]
end

