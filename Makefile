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

compose_debug:
	docker compose -v -f srcs/docker-compose.yml up -d

clean:
	docker-compose down -v

kill:
	docker rm $$(docker ps -q) -f
	docker rmi $$(docker images -q) -f
	make ls

ls:
	docker images
	docker ps -a

.PHONY: inception, destroy, re, clean, ls, kill, compose, debug

# Couleurs pour le style
GREEN        = \033[0;32m
YELLOW       = \033[0;33m
RESET        = \033[0m

reset:
	rm -rf .env *.secret
	make env
	make secrets

env:
	@if [ ! -f .env ]; then \
		echo "$(YELLOW)--- Configuration du fichier .env ---$(RESET)"; \
		read -p "(DB_NAME) : " dbname; \
		read -p "(USER_LOGIN) : " login; \
		read -p "(DOMAIN_NAME) : " domain; \
		echo "MYSQL_DATABASE=$$dbname" > .env; \
		echo "MYSQL_USER=$$login" >> .env; \
		echo "DOMAIN_NAME=$$domain" >> .env; \
		echo "$(GREEN).env créé avec succès.$(RESET)"; \
	else \
		echo ".env existe déjà, passage à l'étape suivante."; \
	fi

secrets:
	@if [ ! -f secrets/mariadb_root_password.secret ]; then \
		echo "$(YELLOW)--- Configuration des Secrets (Saisie masquée) ---$(RESET)"; \
		printf "Mot de passe ROOT MariaDB : "; \
		stty -echo; \
		read rootpass; \
		stty echo; \
		echo ""; \
		printf "Mot de passe UTILISATEUR MariaDB : "; \
		stty -echo; \
		read userpass; \
		stty echo; \
		echo ""; \
		echo "$$rootpass" > mariadb_root_password.secret; \
		echo "$$userpass" > mariadb_password.secret; \
		echo "$(GREEN)Fichiers secrets créés avec succès.$(RESET)"; \
	else \
		echo "Les secrets existent déjà."; \
	fi

.PHONY: setup env secrets
