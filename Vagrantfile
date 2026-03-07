# **************************************************************************** #
#                                                                              #
#    Vagrantfile                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    Created: 2026/03/06 16:40:51 by aykrifa           #+#    #+#              #
#                                                                              #
# **************************************************************************** #

# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	## Box Ubuntu 22.04 LTS (compatible VirtualBox et libvirt)
	#config.vm.box = "generic/ubuntu2204"

	# Basic box alpine version ?
 	config.vm.box = "generic-x64/alpine319"
 	config.vm.box_version = "4.3.12"

	# Nom d'hôte de la VM
	config.vm.hostname = "aykrifa"

	# Réseau privé avec IP statique
	# config.vm.network "private_network", ip: "192.168.56.10"

	# Dossier synchronisé (désactivé ici pour éviter les dépendances)
	config.vm.synced_folder ".", "/shared", disabled: false

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
		# suppression des paquets qui peuvent entrer en conflit
		sudo apk remove docker-compose docker-doc podman-docker containerd runc
		# Installer dependances de base ici
		sudo apk add ca-certificates curl
		# Installer docker
		sudo apk add docker docker-cli docker-cli-compose
		# Connecting to the Docker daemon through its socket requires you to add yourself to the docker group. 
		addgroup vagrant docker
		# To start the Docker daemon at boot, see OpenRC. 
		rc-update add docker default
		service docker start
	SHELL
end
