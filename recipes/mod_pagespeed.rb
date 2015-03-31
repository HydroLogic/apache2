#
# Cookbook Name:: apache2
# Recipe:: mod_pagespeed
#
# Copyright 2013, ZOZI
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

if %w(rhel debian fedora).include?(node['platform_family'])
  case node['platform_family']
  when 'rhel', 'fedora'
    pkg = 'mod-pagespeed.rpm'
  when 'debian'
    pkg = 'mod-pagespeed.deb'
  end

  remote_file "#{Chef::Config[:file_cache_path]}/#{pkg}" do
    source node['apache2']['mod_pagespeed']['package_link']
    mode '0644'
    action :create_if_missing
  end

  package 'mod_pagespeed' do
    source "#{Chef::Config[:file_cache_path]}/#{pkg}"
    action :install
  end

  apache_module 'pagespeed' do
    conf true
    if node['apache']['version'] == '2.2'
      filename 'mod_pagespeed.so'
      name 'mod_pagespeed'
    elsif node['apache']['version'] == '2.4'
      filename 'mod_pagespeed_ap24.so'
      name 'mod_pagespeed_ap24'
    end
  end
else
  Chef::Log.warn "apache::mod_pagespeed does not support #{node['platform_family']} yet, and is not being installed"
end
