#
# Cookbook Name:: chef-handler-sensu
# Recipe:: default
#
# Copyright (C) 2013 Needle, Inc.
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

include_recipe 'chef_handler'

handler_file = ::File.join(node['chef_handler']['handler_path'], 'sensu_handlers.rb')

cookbook_file handler_file do
  source 'handlers/sensu_handlers.rb'
  mode 0640
  owner 'root'
  group 'root'
  action :nothing
end.run_action(:create)

ruby_block 'trigger_start_handlers' do
  block do
    require 'chef/run_status'
    require 'chef/handler'
    Chef::Handler.run_start_handlers(Chef::RunStatus)
  end
  action :nothing
end

if node['chef_client']['sensu_api_url']
  chef_handler "Chef::Handler::Sensu::Silence" do
    source handler_file
    arguments :api => node['chef_client']['sensu_api_url'],
              :timeout => node['chef_client']['sensu_stash_timeout'],
              :client => node.name,
              :ca_file => node['chef_client']['sensu_ca_file'],
              :verify_mode => node['chef_client']['sensu_verify_mode'],
              :user => node['chef_client']['sensu_api_user'],
              :pass => node['chef_client']['sensu_api_pass']
    supports :start => true
    notifies :create, "ruby_block[trigger_start_handlers]", :immediately
    action :enable
  end.run_action(:enable)

  chef_handler "Chef::Handler::Sensu::Unsilence" do
    source handler_file
    arguments :api => node['chef_client']['sensu_api_url'],
              :client => node.name,
              :ca_file => node['chef_client']['sensu_ca_file'],
              :verify_mode => node['chef_client']['sensu_verify_mode'],
              :user => node['chef_client']['sensu_api_user'],
              :pass => node['chef_client']['sensu_api_pass']
    supports :report => true, :exception => true
    action :enable
  end.run_action(:enable)
else
  Chef::Log.error("Could not activate Sensu handlers, node['chef_client']['sensu_api_url'] is not set.")
end
