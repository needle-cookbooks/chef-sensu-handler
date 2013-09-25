#
# Cookbook Name:: sensu-handler-test
# Recipe:: default
#
# Copyright 2013, Needle Inc.
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

include_recipe 'chef-sensu-handler::default'

log "success" do
  message "chef-sensu-handler test succeded!"
  action :nothing
end

if node['chef_client']['sensu_api_url']
  http_request "check_for_silence" do
    url node['chef_client']['sensu_api_url'] + '/stashes/silence/' + node.name
    action :get
    notifies :write, "log[success]", :immediately
  end
else
  Chef::Log.fatal!("Could not test Sensu handlers, node['chef_client']['sensu_api_url'] is not set.")
end
