# **************************************************************************** #
#                          PASSWORD | .ENV                                     #
# **************************************************************************** #

# Couleurs pour le style
GREEN        = \033[0;32m
YELLOW       = \033[0;33m
RESET        = \033[0m

reset: # reset env and secret
	rm -rf .env *.secret
	make env
	make secrets

env: # build .env
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

secrets: # build passwd
	@if [ ! -f secrets/mariadb_root_password.secret ]; then \
		printf "Mot de passe ROOT MariaDB : "; \
		stty -echo; \
		read rootpass; \
		stty echo; \
		echo ""; \
		printf "Mot de passe USER MariaDB : "; \
		stty -echo; \
		read userpass; \
		stty echo; \
		echo ""; \
		echo "$$rootpass" > mariadb_root_password.secret; \
		echo "$$userpass" > mariadb_password.secret; \
	else \
		echo "Les secrets existent déjà."; \
	fi

.PHONY: setup env secrets
