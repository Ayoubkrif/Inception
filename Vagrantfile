# **************************************************************************** #
#                                                                              #
#    Vagrantfile                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    Created: 2026/03/06 16:40:51 by aykrifa           #+#    #+#              #
#                                                                              #
# **************************************************************************** #

# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	# Box Ubuntu 22.04 LTS (compatible VirtualBox et libvirt)
	config.vm.box = "generic/ubuntu2204"

	# Nom d'hôte de la VM
	config.vm.hostname = "aykrifa"

	# Réseau privé avec IP statique
	config.vm.network "private_network", ip: "192.168.56.10"

	# Dossier synchronisé (désactivé ici pour éviter les dépendances)
	config.vm.synced_folder ".", "/vagrant", disabled: false

	# Configuration pour VirtualBox
	config.vm.provider "virtualbox" do |vb|
		vb.memory = "1024"
		vb.cpus = 1
		vb.name = "Inception"
	end

	# Create a forwarded port mapping which allows access to a specific port
	# within the machine from a port on the host machine and only allow access
	# via 127.0.0.1 to disable public access
	config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"


	# Provisionnement avec Shell
	config.vm.provision "shell", inline: <<-SHELL
		apt-get update -qq
		apt-get install -y htop curl
	SHELL
end
