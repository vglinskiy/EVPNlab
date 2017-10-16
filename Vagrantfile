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
          sudo ip route add 192.168.200.0/24 via 192.168.100.1
          sudo apt-get install tcpdump
          sudo apt-get install traceroute
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
          sudo ip addr add 192.168.200.200/24 dev enp0s8
          sudo ip link set enp0s8 up
          sudo ip route add 192.168.100.0/24 via 192.168.200.1
          sudo apt-get install tcpdump
          sudo apt-get install traceroute
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
        vtepA.vm.network "private_network", auto_config: false, virtualbox__intnet: "vtepA_router1"
        vtepA.vm.provider :virtualbox do |vb|
                vb.name = "vtepA"
                vb.customize ['modifyvm',:id,'--macaddress1','0800276CEE0D']
                vb.customize ['modifyvm',:id,'--nicpromisc2','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc3','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc4','allow-all']
                vb.customize ['modifyvm',:id,'--uart1','0x3F8','4']
                vb.customize ['modifyvm',:id,'--uartmode1','server','/tmp/vtepa']
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
                vb.customize ['modifyvm',:id,'--macaddress1','080027C48D62']
                vb.customize ['modifyvm',:id,'--nicpromisc2','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc3','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc4','allow-all']
                vb.customize ['modifyvm',:id,'--uart1','0x3F8','4']
                vb.customize ['modifyvm',:id,'--uartmode1','server','/tmp/vtepb']
                vb.customize "pre-boot", [
                        "storageattach", :id,
                        "--storagectl", "SATA",
                        "--port", "1",
                        "--device", "0",
                        "--type", "dvddrive",
                        "--medium", "./vtepb_config.iso",
                ]
        end
  end
  config.vm.define "spine" do |spine|
        spine.vm.box = "n9k"
        spine.ssh.insert_key = false
        spine.vm.boot_timeout = 180
        spine.vm.synced_folder '.', '/vagrant', disabled: true
        spine.vm.network :forwarded_port, guest: 80, host: 8883, id: 'http'
        spine.vm.network "private_network", ip: "192.168.1.2", auto_config: false, virtualbox__intnet: "vtepA_spine"
        spine.vm.network "private_network", auto_config: false, virtualbox__intnet: "vtepB_spine"
        spine.vm.provider :virtualbox do |vb|
                vb.name = "spine"
                vb.customize ['modifyvm',:id,'--macaddress1','0800273CD2DE']
                vb.customize ['modifyvm',:id,'--nicpromisc2','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc3','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc4','allow-all']
                vb.customize ['modifyvm',:id,'--uart1','0x3F8','4']
                vb.customize ['modifyvm',:id,'--uartmode1','server','/tmp/spine']
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
  config.vm.define "router1" do |router1|
        router1.vm.box = "n9k"
        router1.ssh.insert_key = false
        router1.vm.boot_timeout = 180
        router1.vm.synced_folder '.', '/vagrant', disabled: true
        router1.vm.network :forwarded_port, guest: 80, host: 8884, id: 'http'
        router1.vm.network "private_network", ip: "192.168.1.2", auto_config: false, virtualbox__intnet: "vtepA_router1"
        router1.vm.provider :virtualbox do |vb|
                vb.name = "router1"
                vb.customize ['modifyvm',:id,'--macaddress1','080027C49A22']
                vb.customize ['modifyvm',:id,'--nicpromisc2','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc3','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc4','allow-all']
                vb.customize ['modifyvm',:id,'--uart1','0x3F8','4']
                vb.customize ['modifyvm',:id,'--uartmode1','server','/tmp/router1']
                vb.customize "pre-boot", [
                        "storageattach", :id,
                        "--storagectl", "SATA",
                        "--port", "1",
                        "--device", "0",
                        "--type", "dvddrive",
                        "--medium", "./router1_config.iso",
                ]
        end
  end
end
  
