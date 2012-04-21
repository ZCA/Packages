#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: zca_build_server
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

# packages that are required on every platform
default['zca_build_server']['packages']['base'] =  
    %w{tk unixODBC bc unzip binutils gcc make swig autoconf wget }
    
# additional packages that are required for ubuntu
default['zca_build_server']['packages']['ubuntu'] = 
    %w{ libdbi-perl libsnmp-base libsnmp15 snmp snmpd libsnmp-dev libgmp3-dev build-essential libxml2-dev libreadline6-dev libpango1.0-dev libgcj10 ccache gcc-4.4 libxslt1-dev libcairo2-dev libglib2.0-dev libevent-dev ldap-utils libldap2-dev libsasl2-dev }

# additional packages that are required for redhat and derivatives
default['zca_build_server']['packages']['redhat'] = 
    %w{ perl-DBI rpm-build net-snmp net-snmp-utils gmp libgomp libxslt gcc-c++ libxml2-devel pango-devel liberation-mono-fonts liberation-sans-fonts liberation-serif-fonts}
    
#TODO: pick SUSE packages
default['zca_build_server']['packages']['suse'] = %w{ }



case platform
when "centos","redhat","fedora","scientific","amazon"
    default['zca_build_server']['build_packages'] = default['zca_build_server']['packages']['base'] + default['zca_build_server']['packages']['redhat']
    
 	#These Packages failed on Centos 5.7, so handle them as such
	if node.platform_version != "5.7"
		default['zca_build_server']['build_packages'] += ["liberation-fonts-common"]
	else
		#Centos 5x its liberation-fonts, not common
		default['zca_build_server']['build_packages'] += ["liberation-fonts", "protobuf-devel"]
		#Chef::Log.debug("TODO: Figure out what to do with protobuf-c package #{node['platform']} #{node['platform_version']}")
	end


# ubuntu build package set
when "ubuntu"
    default['zca_build_server']['build_packages'] = default['zca_build_server']['packages']['base'] + default['zca_build_server']['packages']['ubuntu']


# suse build package set
when "suse"
    #TODO support them 
    Chef::Log.warn("Suse build servers are currently unsupported")
    default['zca_build_server']['build_packages'] = default['zca_build_server']['packages']['base'] + default['zca_build_server']['packages']['suse']


else
    Chef::Log.warn("Platform #{platform} is currently unsupported")
end


Chef::Log.info("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
Chef::Log.info("#{node[:platform]}")
Chef::Log.info("determined the following package set: #{default['zca_build_server']['build_packages']}")
