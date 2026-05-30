# **************************************************************************** #
#                          VIRTUAL MACHINE                                     #
# **************************************************************************** #
vm: # build vm with vagrant
	VBoxManage setproperty machinefolder $$(pwd)
	vagrant up
	vagrant ssh

destroy: # vagrant destroy properly
	ssh-keygen -R "[localhost]:2222"
	vagrant destroy -f

rebuild: destroy # rebuild destroy + vm
	$(MAKE) vm

.PHONY: vm, destroy, rebuild
