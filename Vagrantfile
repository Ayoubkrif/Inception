# **************************************************************************** #
#                                                                              #
#    Vagrantfile                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    Created: 2026/03/06 16:40:51 by aykrifa           #+#    #+#              #
#                                                                              #
# **************************************************************************** #

### Current config
Vagrant.configure("2") do |config|
  ## Basic box alpine version ?
 	config.vm.box = "generic-x64/alpine319"
 	config.vm.box_version = "4.3.12"

	## Nom d'hôte de la VM
	config.vm.hostname = "aykrifa"

	## Réseau privé avec IP statique
	config.vm.network "private_network", ip: "192.168.56.10"

	##INFO: Sync Folder
	config.vm.synced_folder ".", "/shared", disabled: false, mount_options: ["dmode=775", "fmode=664"]

	## Configuration pour VirtualBox
	config.vm.provider "virtualbox" do |vb|
		vb.memory = "4096"
		vb.cpus = 4
		vb.name = ENV['BOX_NAME'] || "Inception_VBox"
	end
	#INFO: Create a forwarded port mapping which allows access to a specific port
	# within the machine from a port on the host machine and only allow access
	# via 127.0.0.1 to disable public access
	# config.vm.network "forwarded_port_name", guest: XXXX, host: XXXX, host_ip: "X.X.X.X"

	#INFO: provision script
	config.vm.provision "shell", path: "provision.sh"
end

