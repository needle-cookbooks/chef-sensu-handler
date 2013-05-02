include_recipe 'chef-sensu-handler::default'

http_request "check_for_silence" do
  url node['chef_client']['sensu_api_url'] + '/stashes/silence/' + node.name
  action :get
end
