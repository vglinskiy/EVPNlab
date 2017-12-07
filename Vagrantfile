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
          sudo ip route add 100.0.0.0/8 via 192.168.100.1
          sudo apt-get -y install traceroute
          sudo apt-get -y install tcpdump
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
          sudo ip route add 100.0.0.0/8 via 192.168.200.1
          sudo apt-get -y install traceroute
          sudo apt-get -y install tcpdump
        SHELL
        hostB.vm.hostname = "hostB"
  end
  
  config.vm.define "hostC" do |hostC|
    config.vm.provider "virtualbox" do |hostC|
      hostC.name = "hostC"
    end
    hostC.vm.box = "minimal/xenial64"
	hostC.vm.network :forwarded_port, guest: 22, host: 12204, id: 'ssh'
	hostC.vm.network "private_network", virtualbox__intnet: "hostC_vtepA", auto_config: false
	hostC.vm.provision "shell", inline: <<-SHELL
          sudo ip addr add 172.16.100.100/24 dev enp0s8
          sudo ip link set enp0s8 up
          sudo ip route add 172.16.200.0/24 via 172.16.100.1
          sudo ip route add 100.0.0.0/8 via 172.16.100.1
          sudo apt-get -y install traceroute
          sudo apt-get -y install tcpdump
        SHELL
        hostC.vm.hostname = "hostC"
  end
 
  config.vm.define "hostD" do |hostD|
    config.vm.provider "virtualbox" do |hostD|
      hostD.name = "hostD"
    end
    hostD.vm.box = "minimal/xenial64"
	hostD.vm.network :forwarded_port, guest: 22, host: 12205, id: 'ssh'
	hostD.vm.network "private_network", virtualbox__intnet: "hostD_vtepB", auto_config: false
	hostD.vm.provision "shell", inline: <<-SHELL
          sudo ip addr add 172.16.200.200/24 dev enp0s8
          sudo ip link set enp0s8 up
          sudo ip route add 172.16.100.0/24 via 172.16.200.1
          sudo ip route add 100.0.0.0/8 via 172.16.200.1
          sudo apt-get -y install traceroute
          sudo apt-get -y install tcpdump
        SHELL
        hostD.vm.hostname = "hostD"
  end
 
  config.vm.define "outside" do |outside|
    config.vm.provider "virtualbox" do |outside|
      outside.name = "outside"
    end
    outside.vm.box = "minimal/xenial64"
	outside.vm.network :forwarded_port, guest: 22, host: 12206, id: 'ssh'
	outside.vm.network "private_network", virtualbox__intnet: "outside", auto_config: false
	outside.vm.provision "shell", inline: <<-SHELL
          sudo ip addr add 100.100.0.100/24 dev enp0s8
          sudo ip link set enp0s8 up
          sudo ip route add 172.16.100.0/24 via 100.100.0.1
          sudo ip route add 172.16.200.0/24 via 100.100.0.1
          sudo ip route add 192.168.100.0/24 via 100.100.0.1
          sudo ip route add 192.168.200.0/24 via 100.100.0.1
          sudo ip route add 100.0.0.0/8 via 100.100.0.1
          sudo apt-get -y install traceroute
          sudo apt-get -y install tcpdump
        SHELL
        outside.vm.hostname = "outside"
  end
 
  config.vm.define "vtepA" do |vtepA|
        vtepA.vm.box = "n9k"
        vtepA.ssh.insert_key = false
        vtepA.vm.boot_timeout = 180
        vtepA.vm.synced_folder '.', '/vagrant', disabled: true
        vtepA.vm.network :forwarded_port, guest: 80, host: 8881, id: 'http'
        vtepA.vm.network "private_network", ip: "192.168.1.2", auto_config: false, virtualbox__intnet: "hostA_vtepA"
        vtepA.vm.network "private_network", auto_config: false, virtualbox__intnet: "vtepA_spine"
        vtepA.vm.network "private_network", auto_config: false, virtualbox__intnet: "hostC_vtepA"
        vtepA.vm.provider :virtualbox do |vb|
                vb.name = "vtepA"
                vb.customize ['modifyvm',:id,'--memory','6144']
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
        vtepB.vm.network "private_network", auto_config: false, virtualbox__intnet: "hostD_vtepB"
        vtepB.vm.network "private_network", auto_config: false, virtualbox__intnet: "vtepB_external"
        vtepB.vm.provider :virtualbox do |vb|
                vb.name = "vtepB"
                vb.customize ['modifyvm',:id,'--memory','6144']
                vb.customize ['modifyvm',:id,'--macaddress1','080027C48D62']
                vb.customize ['modifyvm',:id,'--nicpromisc2','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc3','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc4','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc5','allow-all']
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
                vb.customize ['modifyvm',:id,'--memory','8192']
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
  config.vm.define "edge" do |edge|
        edge.vm.box = "n9k"
        edge.ssh.insert_key = false
        edge.vm.boot_timeout = 180
        edge.vm.synced_folder '.', '/vagrant', disabled: true
        edge.vm.network :forwarded_port, guest: 80, host: 8884, id: 'http'
        edge.vm.network "private_network", ip: "192.168.1.2", auto_config: false, virtualbox__intnet: "vtepB_external"
        edge.vm.network "private_network", auto_config: false, virtualbox__intnet: "outside"
        edge.vm.provider :virtualbox do |vb|
                vb.name = "edge"
                vb.customize ['modifyvm',:id,'--memory','8192']
                vb.customize ['modifyvm',:id,'--macaddress1','0800273CD255']
                vb.customize ['modifyvm',:id,'--nicpromisc2','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc3','allow-all']
                vb.customize ['modifyvm',:id,'--nicpromisc4','allow-all']
                vb.customize ['modifyvm',:id,'--uart1','0x3F8','4']
                vb.customize ['modifyvm',:id,'--uartmode1','server','/tmp/edge']
                vb.customize "pre-boot", [
                        "storageattach", :id,
                        "--storagectl", "SATA",
                        "--port", "1",
                        "--device", "0",
                        "--type", "dvddrive",
                        "--medium", "./edge_config.iso",
                ]
        end
  end
end
  
