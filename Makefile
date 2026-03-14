# **************************************************************************** #
#                                                                              #
#    Makefile                                           :+:      :+:    :+:    #
#    By: aykrifa <aykrifa@student.42.fr>            +#+  +:+       +#+         #
#    Created: 2026/03/07 18:25:14 by aykrifa           #+#    #+#              #
#                                                                              #
# **************************************************************************** #

inception:
	VBoxManage setproperty machinefolder $$(pwd)
	cp ~/.ssh/vm .
	cp ~/.ssh/vm.pub .
	vagrant up
	vagrant ssh

destroy:
	rm -f vm
	rm -f vm.pub
	ssh-keygen -R "[localhost]:2222"
	vagrant destroy -f

re: destroy
	$(MAKE) inception

compose:
	docker compose -f srcs/docker-compose.yml up -d

stop:
	docker compose down

kill:
	docker rm $$(docker ps -q) -f
	docker rmi $$(docker images -q) -f
	make ls

ls:
	docker images
	docker ps -a

.PHONY: inception, destroy, re
