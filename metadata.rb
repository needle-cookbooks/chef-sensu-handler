name             "chef-sensu-handler"
maintainer       "Needle Inc."
maintainer_email "cookbooks@needle.com"
license          "Apache 2.0"
description      "Installs/Configures a pair of Chef handlers for silencing/unsilencing Sensu clients"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.1"

depends 'chef_handler', '>= 1.0.4'

