# **************************************************************************** #
#                          VIRTUAL MACHINE                                     #
# **************************************************************************** #

BOX_NAME = Inception_VBox

$(BOX_NAME): # build vm with vagrant
	VBoxManage setproperty machinefolder $$(pwd)
	BOX_NAME=$(BOX_NAME) vagrant up
	$(MAKE) ssh

ssh: # se connecter en aykrifa dans la VM
	vagrant ssh -- -tt sudo su - aykrifa

browser: # ouvre Firefox dans la VM via X11 forwarding
	ssh -Y -p 2222 \
		-i .vagrant/machines/default/virtualbox/private_key \
		-o StrictHostKeyChecking=no \
		-o UserKnownHostsFile=/dev/null \
		vagrant@127.0.0.1 firefox

destroy: # vagrant destroy properly
	ssh-keygen -R "[localhost]:2222"
	ssh-keygen -R "[127.0.0.1]:2222"
	vagrant destroy -f

vm_re: destroy # rebuild destroy + vm
	rm -rf $(BOX_NAME)
	$(MAKE) $(BOX_NAME)

reboot: # éteint et rallume la VM
	vagrant halt
	vagrant up
	$(MAKE) ssh

.PHONY: ssh browser destroy rebuild reboot
