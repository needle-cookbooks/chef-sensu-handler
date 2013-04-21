# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "chef-handler-sensu-berkshelf"
  config.vm.box = "opscode-ubuntu-12.04"
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/boxes/opscode-ubuntu-12.04.box"
  config.vm.network :public_network

  config.berkshelf.enabled = true
  config.omnibus.chef_version = "10.24.0"

  config.ssh.max_tries = 40
  config.ssh.timeout   = 120

  config.vm.provision :chef_solo do |chef|
    chef.json = {}

    chef.run_list = [
      "recipe[chef-handler-sensu::default]"
    ]
  end
end
