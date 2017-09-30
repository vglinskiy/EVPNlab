# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.define "hostA" do |hostA|
    config.vm.provider "virtualbox" do |hostA|
      hostA.name = "hostA"
    end
    hostA.vm.box = "minimal/xenial64"
	hostA.vm.network :forwarded_port, guest: 22, host: 12200, id: 'ssh'
	hostA.vm.network "private_network", virtualbox__intnet: "hostA_vtepA", auto_config: false
	hostA.vm.provision "shell", inline: <<-SHELL
          sudo ip addr add 192.168.100.100/24 dev enp0s8
          sudo ip link set enp0s8 up
        SHELL
        hostA.vm.hostname = "hostA"
  end
  
    config.vm.define "hostB" do |hostB|
    config.vm.provider "virtualbox" do |hostB|
      hostB.name = "hostB"
    end
    hostB.vm.box = "minimal/xenial64"
	hostB.vm.network :forwarded_port, guest: 22, host: 12202, id: 'ssh'
	hostB.vm.network "private_network", virtualbox__intnet: "hostB_vtepB", auto_config: false
	hostB.vm.provision "shell", inline: <<-SHELL
          sudo ip addr add 192.168.100.200/24 dev enp0s8
          sudo ip link set enp0s8 up
        SHELL
        hostB.vm.hostname = "hostB"
  end
  
  config.vm.define "vtepA" do |vtepA|
        vtepA.vm.box = "n9k"
        vtepA.ssh.insert_key = false
        vtepA.vm.boot_timeout = 180
        vtepA.vm.synced_folder '.', '/vagrant', disabled: true
        vtepA.vm.network :forwarded_port, guest: 80, host: 8881, id: 'http'
        vtepA.vm.network "private_network", ip: "192.168.1.2", auto_config: false, virtualbox__intnet: "hostA_vtepA"
        vtepA.vm.network "private_network", auto_config: false, virtualbox__intnet: "vtepA_spine"
        vtepA.vm.provider :virtualbox do |vb|
                vb.name = "vtepA"
                vb.customize ['modifyvm',:id,'--nicpromisc2','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc3','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc4','allow-all']
                vb.customize "pre-boot", [
                        "storageattach", :id,
                        "--storagectl", "SATA",
                        "--port", "1",
                        "--device", "0",
                        "--type", "dvddrive",
                        "--medium", "./vtepa_config.iso",
                ]
        end
  end
  config.vm.define "vtepB" do |vtepB|
        vtepB.vm.box = "n9k"
        vtepB.ssh.insert_key = false
        vtepB.vm.boot_timeout = 180
        vtepB.vm.synced_folder '.', '/vagrant', disabled: true
        vtepB.vm.network :forwarded_port, guest: 80, host: 8882, id: 'http'
        vtepB.vm.network "private_network", ip: "192.168.1.2", auto_config: false, virtualbox__intnet: "hostB_vtepB"
        vtepB.vm.network "private_network", auto_config: false, virtualbox__intnet: "vtepB_spine"
        vtepB.vm.provider :virtualbox do |vb|
                vb.name = "vtepB"
                vb.customize ['modifyvm',:id,'--nicpromisc2','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc3','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc4','allow-all']
                vb.customize "pre-boot", [
                        "storageattach", :id,
                        "--storagectl", "SATA",
                        "--port", "1",
                        "--device", "0",
                        "--type", "dvddrive",
                        "--medium", "./vtepB_config.iso",
                ]
        end
  end
  config.vm.define "spine" do |spine|
        spine.vm.box = "n9k"
        spine.ssh.insert_key = false
        spine.vm.boot_timeout = 180
        spine.vm.synced_folder '.', '/vagrant', disabled: true
        spine.vm.network :forwarded_port, guest: 80, host: 8883, id: 'http'
        spine.vm.network "private_network", ip: "192.168.1.2", auto_config: false, virtualbox__intnet: "hostA_spine"
        spine.vm.network "private_network", auto_config: false, virtualbox__intnet: "hostB_spine"
        spine.vm.provider :virtualbox do |vb|
                vb.name = "spine"
                vb.customize ['modifyvm',:id,'--nicpromisc2','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc3','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc4','allow-all']
                vb.customize "pre-boot", [
                        "storageattach", :id,
                        "--storagectl", "SATA",
                        "--port", "1",
                        "--device", "0",
                        "--type", "dvddrive",
                        "--medium", "./spine_config.iso",
                ]
        end
  end
end
  
