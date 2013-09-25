# chef-handler-sensu

This cookbook installs a pair of Chef handlers for silencing and unsilencing Sensu checks against a specified client via the Sensu API.

# Requirements

Depends on the `chef_handler` cookbook

# Usage

Include this cookbook's default recipe in another recipe or role near the beginning of the node's run list so that the start handler can take effect early on.

# Attributes

`chef_client.sensu_api_url` - the URL of your Sensu API end point (defaults to nil)
`chef_client.sensu_stash_timeout` - the duration in seconds between when a client is silenced and when that silenced stash should be considered expired (defaults to 3600)

# Recipes

`default` - The default recipe activates `Chef::Handler::Sensu::Silence` as a 'start' handler and `Chef::Handler::Sensu::Unsilence` as both a exception handler and a report handler, and manually triggers the Chef start handlers a second time. This has the effect of silencing Sensu checks against a client matching the name of the Chef node for the duration of the Chef run.

# Author

Author:: Cameron Johnston (<cameron@rootdown.net>)
