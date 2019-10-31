# -*- mode: ruby -*-
# vi: set ft=ruby :

# ---- Configuration variables ----
GUI               = false # Enable/Disable GUI
RAM               = 3072   # Default memory size in MB
CPU               = 2     # Default core sayisi

# Network configuration
DOMAIN            = ".myswarm.org"
NETWORK           = "192.168.60."
NETMASK           = "255.255.255.0"

# Default Virtualbox .box
BOX               = 'debian/stretch64'

# VBox sanal makina tanimlarim
HOSTS = {
  "swarm-manager" => [NETWORK+"11", RAM, GUI, CPU, BOX,"manager"],
  "swarm-worker1" => [NETWORK+"12", RAM, GUI, CPU, BOX,"worker"],
  "swarm-worker2" => [NETWORK+"13", RAM, GUI, CPU, BOX,"worker"],
}

# Hostmanager kurulumu gereklidir.
# vagrant plugin install vagrant-hostmanager
Vagrant.configure("2") do |config|

    config.vm.synced_folder ".", "/vagrant", type: "nfs"

    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
#     config.disksize.size = '20GB'

    # Sanal makinalari olusturuyorum
    HOSTS.each do | (name, cfg) |
      ipaddr, ram, gui, cpu, box, type = cfg

      config.vm.define name do |machine|
        machine.vm.box   = box
        machine.vm.guest = :debian

        machine.vm.provider "virtualbox" do |vbox|
          vbox.gui = gui
          vbox.memory = ram
          vbox.name = name
          vbox.cpus = cpu
        end

        machine.vm.hostname = name + DOMAIN
        machine.vm.network 'private_network', ip: ipaddr, netmask: NETMASK
#       machine.vm.network "public_network", use_dhcp_assigned_default_route: true
        machine.hostmanager.aliases = [name ]

        # -------- PROVISION -------------------
        # hostmanager provisioner
        config.vm.provision :hostmanager

        # call external script to install
        config.vm.provision "shell", path: "scripts/commonPackages.sh"

        # call external script to install CRI
        config.vm.provision "shell", path: "scripts/installDocker.sh"

        if type == "manager"
          machine.vm.provision "shell", path: "scripts/configureManager.sh", :args => ipaddr
        elsif type == "worker"
          machine.vm.provision "shell", path: "scripts/configureWorker.sh"
        end

      end
    end # HOSTS-each

end
