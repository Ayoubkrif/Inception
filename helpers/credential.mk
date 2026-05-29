# **************************************************************************** #
#                          PASSWORD | .ENV                                     #
# **************************************************************************** #

# Couleurs pour le style
GREEN        = \033[0;32m
YELLOW       = \033[0;33m
RESET        = \033[0m

reset: # reset env and secret
	cd srcs/ && rm -rf .env *.secret
	make env
	make secrets

env: # build .env
	@cd srcs/ && if [ ! -f .env ]; then \
		read -p "(DB_NAME) : " dbname; \
		read -p "(USER_LOGIN) : " login; \
		\
		echo "MYSQL_DATABASE=$$dbname" > .env; \
		echo "MYSQL_USER=$$login" >> .env; \
		echo "HOST_DATA_PATH=/home/vagrant/DB" >> .env; \
		echo "WP_FILES_LOCATION=/var/www/html" >> .env; \
	else \
		echo ".env already exist"; \
	fi

secrets: # build passwd
	@cd srcs/ && if [ ! -f mariadb_root_password.secret ]; then \
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
		echo "secret already exist"; \
	fi

.PHONY: setup env secrets
