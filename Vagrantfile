# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.require_version ">= 1.8.5"

ANSIBLE_INVENTORY = 'vagrant-swarm'
ANSIBLE_PLAYBOOK = 'docker.yml'
ANSIBLE_SKIP_TAGS = []

DEFAULT_HOST_VARS = {
  "vagrant_skip"   => "no",
  "vagrant_box"    => "bento/ubuntu-16.04",
  "vagrant_box_version" => "= 2.2.9",
  "vagrant_memory" => "1024",
  "vagrant_cpus"   => "1",
}

require 'ansibler'
inventory = Ansible::Inventory.read_file(ANSIBLE_INVENTORY)

puts "Reading the Ansible inventory file #{ANSIBLE_INVENTORY} and merging values for hosts..."
$global_hosts = {}
inventory.groups.each do |group|
  group.hosts.each do |host|
    if not $global_hosts.has_key? host.name
      $global_hosts[host.name] = DEFAULT_HOST_VARS.clone
    end
    $global_hosts[host.name].merge!(host.vars)
    if $global_hosts[host.name]['vagrant_skip'] == "no"
      puts "+ [#{group.name}] #{host.name} #{$global_hosts[host.name]}" if ENV['VERBOSE_ANSIBLE_INVENTORY']
    else
      puts "- [#{group.name}] #{host.name} #{$global_hosts[host.name]}" if ENV['VERBOSE_ANSIBLE_INVENTORY']
    end
  end
end
$global_enabled_hosts = $global_hosts.select{|h,v| v["vagrant_skip"] == "no"}

Vagrant.configure("2") do |config|

  # set to false, if you do NOT want to check the correct VirtualBox Guest Additions version when booting this box
  if defined?(VagrantVbguest::Middleware)
    config.vbguest.auto_update = true
  end

  config.ssh.insert_key = false

  # Need to be installed with:
  # `vagrant plugin install vagrant-hostmanager`
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = ENV['HOSTMANAGER_MANAGE_HOST'] ? true : false
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  # Defining boxes only for 'enabled' hosts
  $global_enabled_hosts.each do |hostname, vals|
    config.vm.define hostname do |machine|
      machine.vm.box = vals["vagrant_box"]
      machine.vm.box_version = vals["vagrant_box_version"]
      if vals.has_key? "ansible_host"
        machine.vm.network :private_network, ip: vals["ansible_host"]
      end

      machine.vm.provider :virtualbox do |v|
        v.linked_clone = true
        # v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
        file_to_disk = hostname
        v.customize ['createhd', '--filename', file_to_disk, '--size', 1 * 1024]
        v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
        if vals.has_key? "vagrant_memory"
          v.memory = vals["vagrant_memory"]
        end
        if vals.has_key? "vagrant_cpus"
          v.cpus = vals["vagrant_cpus"]
        end
      end

    end
  end

end
