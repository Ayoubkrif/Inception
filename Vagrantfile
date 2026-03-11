# **************************************************************************** #
#                                                                              #
#    Vagrantfile                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    Created: 2026/03/06 16:40:51 by aykrifa           #+#    #+#              #
#                                                                              #
# **************************************************************************** #

# vi: set ft=ruby :

  # Example configuration of new VM..
  #
  #config.vm.define :test_vm do |test_vm|
    # Box name
    #
    #test_vm.vm.box = "centos64"

    # Domain Specific Options
    #
    # See README for more info.
    #
    #test_vm.vm.provider :libvirt do |domain|
    #  domain.memory = 2048
    #  domain.cpus = 2
    #end

    # Interfaces for VM
    #
    # Networking features in the form of `config.vm.network`
    #
    #test_vm.vm.network :private_network, :ip => '10.20.30.40'
    #test_vm.vm.network :public_network, :ip => '10.20.30.41'
  #end

Vagrant.configure("2") do |config|
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
        
    # Options for Libvirt Vagrant provider.
    config.vm.provider :libvirt do |libvirt|

      # A hypervisor name to access. Different drivers can be specified, but
      # this version of provider creates KVM machines only. Some examples of
      # drivers are KVM (QEMU hardware accelerated), QEMU (QEMU emulated),
      # Xen (Xen hypervisor), lxc (Linux Containers),
      # esx (VMware ESX), vmwarews (VMware Workstation) and more. Refer to
      # documentation for available drivers (http://libvirt.org/drivers.html).
        libvirt.driver = "kvm"

      # The name of the server, where Libvirtd is running.
      # libvirt.host = "localhost"

      # If use ssh tunnel to connect to Libvirt.
      libvirt.connect_via_ssh = false

      # The username and password to access Libvirt. Password is not used when
      # connecting via ssh.
      libvirt.username = "aykrifa"
      libvirt.password = "adm"

      # Libvirt storage pool name, where box image and instance snapshots will
      # be stored.
      libvirt.storage_pool_name = "inception"

        # Set a prefix for the machines that's different than the project dir name.
        #libvirt.default_prefix = ''

        # --- Configuration pour Libvirt (Fedora Natif) ---
          libvirt.memory = 1024
          libvirt.cpus = 1
    end

	# Create a forwarded port mapping which allows access to a specific port
	# within the machine from a port on the host machine and only allow access
	# via 127.0.0.1 to disable public access
	# config.vm.network "forwarded_port", guest: 0000, host: 0000, host_ip: "127.0.0.1"
	config.vm.network "forwarded_port", guest: 443, host: 443, host_ip: "127.0.0.1"


	# Provisionnement avec Shell
	config.vm.provision "shell", inline: <<-SHELL
		
                # suppression des paquets qui peuvent entrer en conflit
		sudo apk del docker-compose docker-doc podman-docker containerd runc
                # Installer dependances de base ici
		sudo apk add ca-certificates curl
                # Installer docker
		sudo apk add docker docker-cli docker-cli-compose
                # Create user 
                sudo adduser -h /home/aykrifa -s /bin/bash aykrifa



                # Connecting to the Docker daemon through its socket requires you to add yourself to the docker group. 
		addgroup aykrifa docker
                # To start the Docker daemon at boot, see OpenRC. 
		rc-update add docker default
		service docker start
	SHELL
end
