# **************************************************************************** #
#                                                                              #
#    Makefile                                           :+:      :+:    :+:    #
#    By: aykrifa <aykrifa@student.42.fr>            +#+  +:+       +#+         #
#    Created: 2026/03/07 18:25:14 by aykrifa           #+#    #+#              #
#                                                                              #
# **************************************************************************** #


vm:
	vagrant up && vagrant ssh

destroy:
	ssh-keygen -R "[localhost]:2222" && vagrant destroy -f

arch:
	mkdir -p srcs/nginx srcs/wordpress srcs/mariadb
