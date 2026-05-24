# **************************************************************************** #
#                          VIRTUAL MACHINE                                     #
# **************************************************************************** #
vm: # build vm with vagrant
	VBoxManage setproperty machinefolder $$(pwd)
	cp ~/.ssh/vm .
	cp ~/.ssh/vm.pub .
	vagrant up
	vagrant ssh

destroy: # vagrant destroy properly
	rm -f vm
	rm -f vm.pub
	ssh-keygen -R "[localhost]:2222"
	vagrant destroy -f

rebuild: destroy # rebuild destroy + vm
	$(MAKE) vm

.PHONY: vm, destroy, rebuild
